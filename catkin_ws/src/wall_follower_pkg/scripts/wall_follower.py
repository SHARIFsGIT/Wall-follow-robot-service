#!/usr/bin/env python

import math
import rospy
import actionlib
from geometry_msgs.msg import Twist
from sensor_msgs.msg import LaserScan
from wall_follower_pkg.msg import OdomRecordAction, OdomRecordGoal

# Import the service message - alternate method for ROS environment
import sys
try:
    from wall_follower_pkg.srv import FindWall
except ImportError:
    import os
    sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '..', 'devel', 'lib', 'python3', 'dist-packages'))
    from wall_follower_pkg.srv import FindWall
from wall_follower_pkg.srv import FindWall

class WallFollower:
    def __init__(self):
        # Initialize ROS node
        rospy.init_node('wall_follower', anonymous=True)
        
        # Create publisher for velocity commands
        self.velocity_publisher = rospy.Publisher('/cmd_vel', Twist, queue_size=10)
        
        # Subscribe to laser scan topic
        self.laser_subscriber = rospy.Subscriber('/scan', LaserScan, self.laser_callback)
        
        # Distance thresholds for wall following
        self.wall_dist_max = 0.6   # Maximum distance to the wall
        self.wall_dist_min = 0.4   # Minimum distance to the wall
        self.front_distance_threshold = 0.7  # Threshold for front obstacle detection
        
        # Create Twist message for controlling the robot
        self.vel_msg = Twist()
        
        # Set linear and angular velocities
        self.forward_speed = 0.2  # Linear speed
        self.turn_speed = 0.5     # Angular speed
        
        # PID controller parameters for smoother wall following
        self.kp = 3.0  # Proportional gain
        
        # Wait for first laser scan
        self.laser_data = None
        rospy.loginfo("Wall follower node initialized. Waiting for laser data...")
    
    def call_find_wall_service(self):
        """Call the find_wall service to position the robot before starting wall following"""
        rospy.loginfo("Waiting for find_wall service...")
        try:
            rospy.wait_for_service('find_wall', timeout=5.0)
            find_wall = rospy.ServiceProxy('find_wall', FindWall)
            response = find_wall()
            rospy.loginfo("find_wall service response: %s", response.wallfound)
            return response.wallfound
        except rospy.ROSException as e:
            rospy.logerr("Service timeout: %s", e)
            return False
        except rospy.ServiceException as e:
            rospy.logerr("Service call failed: %s", e)
            return False

    def laser_callback(self, data):
        """Process incoming laser scan data"""
        self.laser_data = data
        self.follow_wall()
    
    def get_right_side_distance(self):
        """Get the distance to the wall on the right side of the robot"""
        if self.laser_data is None:
            return float('inf')
        
        # Find the index that corresponds to the 90-degree angle (right side)
        # The angle 0 is directly in front of the robot, 90 degrees is to the right
        right_index = int((math.pi/2 - self.laser_data.angle_min) / self.laser_data.angle_increment)
        
        # Safety check - ensure the index is within valid range
        if right_index >= len(self.laser_data.ranges) or right_index < 0:
            return float('inf')
        
        # Get measurements in a small window around the right side for more stability
        window_size = 5
        start_idx = max(0, right_index - window_size//2)
        end_idx = min(len(self.laser_data.ranges) - 1, right_index + window_size//2)
        
        # Filter invalid readings and get the average
        valid_readings = []
        for i in range(start_idx, end_idx + 1):
            if i < len(self.laser_data.ranges):
                reading = self.laser_data.ranges[i]
                if reading != float('inf') and not math.isnan(reading):
                    valid_readings.append(reading)
        
        # Return average if we have valid readings, otherwise return infinity
        if valid_readings:
            return sum(valid_readings) / len(valid_readings)
        else:
            return float('inf')
    
    def get_front_distance(self):
        """Get the distance to obstacles in front of the robot with averaging for stability"""
        if self.laser_data is None:
            return float('inf')
        
        # Front index (0 degrees is directly in front)
        front_index = int((0 - self.laser_data.angle_min) / self.laser_data.angle_increment)
        
        # Look at a wider angle in front for better obstacle detection
        window_size = 11  # Check 11 points centered at front_index
        start_idx = max(0, front_index - window_size//2)
        end_idx = min(len(self.laser_data.ranges) - 1, front_index + window_size//2)
        
        # Get the minimum distance in the front window (closest obstacle)
        min_distance = float('inf')
        for i in range(start_idx, end_idx + 1):
            if i < len(self.laser_data.ranges):
                distance = self.laser_data.ranges[i]
                if distance != float('inf') and not math.isnan(distance):
                    min_distance = min(min_distance, distance)
        
        return min_distance
    
    def get_angle_for_best_wall_following(self, target_distance):
        """
        Calculate angle that will keep the robot at the target distance from the wall
        This uses a simple proportional controller
        """
        right_distance = self.get_right_side_distance()
        error = target_distance - right_distance
        
        # Apply proportional control
        correction = self.kp * error
        
        # Limit correction to reasonable values
        correction = max(-self.turn_speed, min(correction, self.turn_speed))
        
        return correction
    
    def follow_wall(self):
        """Implement wall following behavior"""
        if self.laser_data is None:
            return
        
        # Get distance to the wall on the right side
        right_distance = self.get_right_side_distance()
        
        # Get distance to obstacles in front of the robot
        front_distance = self.get_front_distance()
        
        # Default to moving forward
        self.vel_msg.linear.x = self.forward_speed
        self.vel_msg.angular.z = 0.0
        
        # Check front distance first - highest priority
        if front_distance < self.front_distance_threshold:
            # Wall or obstacle in front, turn left
            rospy.loginfo("Wall ahead at distance %.2f - turning left", front_distance)
            self.vel_msg.linear.x = self.forward_speed * 0.5  # Slow down while turning
            self.vel_msg.angular.z = self.turn_speed  # Positive = left turn
        
        # Check right distance for wall following
        elif right_distance > self.wall_dist_max * 1.5:
            # Wall is too far or lost, make a sharper right turn to find it
            rospy.loginfo("Wall too far or lost (%.2f) - searching", right_distance)
            self.vel_msg.angular.z = -self.turn_speed * 0.8
        
        elif right_distance > self.wall_dist_max:
            # Too far from the wall, turn right to approach it
            rospy.loginfo("Too far from wall (%.2f) - turning right", right_distance)
            # Use proportional control for smoother approach
            self.vel_msg.angular.z = self.get_angle_for_best_wall_following(
                (self.wall_dist_min + self.wall_dist_max) / 2
            )
        
        elif right_distance < self.wall_dist_min:
            # Too close to the wall, turn left to move away
            rospy.loginfo("Too close to wall (%.2f) - turning left", right_distance)
            # Use proportional control for smoother movement
            self.vel_msg.angular.z = self.get_angle_for_best_wall_following(
                (self.wall_dist_min + self.wall_dist_max) / 2
            )
        
        else:
            # Just right distance, keep moving forward
            rospy.loginfo("Maintaining wall distance (%.2f) - moving forward", right_distance)
            # Small correction to maintain ideal distance
            self.vel_msg.angular.z = self.get_angle_for_best_wall_following(
                (self.wall_dist_min + self.wall_dist_max) / 2
            ) * 0.5
        
        # Publish velocity command
        self.velocity_publisher.publish(self.vel_msg)
    
    def run(self):
        """Main control loop"""
        # First, call the find_wall service to position the robot
        wall_found = self.call_find_wall_service()
        
        if not wall_found:
            rospy.logwarn("Could not find wall, proceeding with wall following anyway")
        else:
            rospy.loginfo("Wall found, starting wall following")

        # Start recording odometry
        action_client = self.call_record_odom_action()
        
        rate = rospy.Rate(10)  # 10 Hz
        rospy.loginfo("Wall follower is running...")
        
        while not rospy.is_shutdown():
            if self.laser_data is not None:
                # If we have laser data, wall following is handled in the callback
                pass
            else:
                rospy.loginfo("Waiting for laser data...")
            
            rate.sleep()

    def call_record_odom_action(self):
        """Call the record_odom action server to start recording odometry"""
        rospy.loginfo("Calling record_odom action server...")

        # Create an action client
        client = actionlib.SimpleActionClient('record_odom', OdomRecordAction)

        # Wait for the server to start up
        rospy.loginfo("Waiting for record_odom action server...")
        client.wait_for_server()

        # Create and send a goal
        goal = OdomRecordGoal()
        client.send_goal(goal, feedback_cb=self.odom_feedback_callback)

        rospy.loginfo("Goal sent to record_odom action server")
        return client

    def odom_feedback_callback(self, feedback):
        """Process feedback from the record_odom action server"""
        rospy.loginfo("Total distance traveled: %.2f meters", feedback.current_total)

if __name__ == '__main__':
    try:
        wall_follower = WallFollower()
        wall_follower.run()
    except rospy.ROSInterruptException:
        rospy.loginfo("Wall follower node terminated.")
