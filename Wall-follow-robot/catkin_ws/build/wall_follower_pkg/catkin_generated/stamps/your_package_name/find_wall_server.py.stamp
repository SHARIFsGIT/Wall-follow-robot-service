#!/usr/bin/env python3

import rospy
import math
from sensor_msgs.msg import LaserScan
from geometry_msgs.msg import Twist
from your_package_name.srv import FindWall, FindWallResponse

class FindWallServer:
    """
    A ROS service server that helps the robot find and position itself 
    in front of the nearest wall.
    """
    
    def __init__(self):
        # Initialize the ROS node
        rospy.init_node('find_wall_server')
        
        # Create publisher for velocity commands
        self.vel_pub = rospy.Publisher('/cmd_vel', Twist, queue_size=10)
        
        # Subscribe to laser scan data
        self.laser_sub = rospy.Subscriber('/scan', LaserScan, self.laser_callback)
        
        # Initialize laser data
        self.laser_data = None
        
        # Create service server
        self.service = rospy.Service('find_wall', FindWall, self.handle_find_wall)
        
        rospy.loginfo("Find Wall Service Server is ready")
        
    def laser_callback(self, data):
        """Store the latest laser scan data"""
        self.laser_data = data
    
    def handle_find_wall(self, req):
        """Service handler to find the nearest wall"""
        if self.laser_data is None:
            rospy.logwarn("No laser data received yet")
            return FindWallResponse(wallfound=False)
            
        # Step 1: Identify which laser ray is the shortest
        ranges = self.laser_data.ranges
        shortest_dist = float('inf')
        shortest_idx = 0
        
        for i, dist in enumerate(ranges):
            # Skip invalid measurements
            if math.isnan(dist) or dist == 0.0:
                continue
                
            if dist < shortest_dist:
                shortest_dist = dist
                shortest_idx = i
        
        angle_min = self.laser_data.angle_min
        angle_increment = self.laser_data.angle_increment
        
        # Calculate angle of the shortest ray
        shortest_angle = angle_min + (shortest_idx * angle_increment)
        
        # Step 2: Rotate robot to face the wall
        self.rotate_to_angle(shortest_angle)
        rospy.sleep(1.0)  # Give time for rotation to complete
        
        # Step 3: Move forward until front ray is less than 30cm
        self.move_forward_until_close()
        rospy.sleep(1.0)  # Give time for movement to complete
        
        # Step 4: Rotate until ray number 270 points to the wall
        # (Assuming 270 is the right-side ray in a 360-degree scan)
        self.rotate_to_right_side_wall()
        
        rospy.loginfo("Robot has found and positioned itself next to the wall")
        return FindWallResponse(wallfound=True)
    
    def rotate_to_angle(self, target_angle):
        """Rotate the robot to face a specific angle"""
        vel_msg = Twist()
        rate = rospy.Rate(10)  # 10 Hz
        
        # Determine rotation direction
        if target_angle > 0:
            vel_msg.angular.z = 0.3  # Rotate counter-clockwise
        else:
            vel_msg.angular.z = -0.3  # Rotate clockwise
            
        # Keep rotating until front ray is pointing to the shortest distance
        start_time = rospy.Time.now()
        timeout = rospy.Duration(10)  # 10 second timeout
        
        while not rospy.is_shutdown():
            # Check if we have recent laser data
            if self.laser_data is None:
                continue
                
            # Find the shortest distance again in current position
            ranges = self.laser_data.ranges
            front_idx = len(ranges) // 2  # Middle ray (assumed to be front)
            
            # If the shortest distance is now in front of the robot (with some tolerance)
            if abs(front_idx - self.find_shortest_ray_idx()) < 5:
                break
                
            # Check for timeout
            if rospy.Time.now() - start_time > timeout:
                rospy.logwarn("Rotation timeout")
                break
                
            self.vel_pub.publish(vel_msg)
            rate.sleep()
            
        # Stop rotation
        vel_msg.angular.z = 0
        self.vel_pub.publish(vel_msg)
    
    def find_shortest_ray_idx(self):
        """Find the index of the shortest valid laser ray"""
        ranges = self.laser_data.ranges
        shortest_dist = float('inf')
        shortest_idx = 0
        
        for i, dist in enumerate(ranges):
            if not math.isnan(dist) and dist > 0.0 and dist < shortest_dist:
                shortest_dist = dist
                shortest_idx = i
                
        return shortest_idx
    
    def move_forward_until_close(self):
        """Move the robot forward until it's close to the wall"""
        vel_msg = Twist()
        vel_msg.linear.x = 0.1  # Slow forward movement
        rate = rospy.Rate(10)
        
        while not rospy.is_shutdown():
            # Check if we have recent laser data
            if self.laser_data is None:
                continue
                
            # Check the front ray (middle of the array)
            ranges = self.laser_data.ranges
            front_idx = len(ranges) // 2
            
            # If front distance is less than 30cm
            if ranges[front_idx] < 0.3:
                break
                
            self.vel_pub.publish(vel_msg)
            rate.sleep()
            
        # Stop movement
        vel_msg.linear.x = 0
        self.vel_pub.publish(vel_msg)
    
    def rotate_to_right_side_wall(self):
        """Rotate the robot so that ray 270 points to the wall"""
        vel_msg = Twist()
        rate = rospy.Rate(10)
        
        # We'll rotate to the left (counter-clockwise)
        vel_msg.angular.z = 0.3
        
        while not rospy.is_shutdown():
            # Check if we have recent laser data
            if self.laser_data is None:
                continue
                
            # Check ray 270 (assuming it's the right-side ray)
            ranges = self.laser_data.ranges
            right_side_idx = 270 % len(ranges)  # Ensure index is within bounds
            
            # If right-side ray detects the wall (use a distance threshold)
            if ranges[right_side_idx] < 0.5:
                break
                
            self.vel_pub.publish(vel_msg)
            rate.sleep()
            
        # Stop rotation
        vel_msg.angular.z = 0
        self.vel_pub.publish(vel_msg)

if __name__ == '__main__':
    try:
        server = FindWallServer()
        rospy.spin()
    except rospy.ROSInterruptException:
        pass