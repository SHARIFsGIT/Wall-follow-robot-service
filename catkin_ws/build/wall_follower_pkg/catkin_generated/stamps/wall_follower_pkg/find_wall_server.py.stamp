#!/usr/bin/env python

import rospy
import math
from sensor_msgs.msg import LaserScan
from geometry_msgs.msg import Twist
from wall_follower_pkg.srv import FindWall, FindWallResponse

class FindWallServer:
    def __init__(self):
        # Initialize ROS node
        rospy.init_node('find_wall_server')
        
        # Create publisher for velocity commands
        self.velocity_publisher = rospy.Publisher('/cmd_vel', Twist, queue_size=10)
        
        # Subscribe to laser scan topic
        self.laser_subscriber = rospy.Subscriber('/scan', LaserScan, self.laser_callback)
        
        # Create the service server
        self.service = rospy.Service('find_wall', FindWall, self.handle_find_wall)
        
        # Create Twist message for controlling the robot
        self.vel_msg = Twist()
        
        # Wait for first laser scan
        self.laser_data = None
        
        rospy.loginfo("Find Wall Service Server initialized. Waiting for laser data...")
    
    def laser_callback(self, data):
        """Process incoming laser scan data"""
        self.laser_data = data
    
    def get_shortest_laser_ray(self):
        """Find the shortest laser ray (closest obstacle)"""
        if self.laser_data is None:
            return -1, float('inf')
        
        min_distance = float('inf')
        min_index = -1
        
        for i, distance in enumerate(self.laser_data.ranges):
            if not math.isnan(distance) and distance < min_distance and distance > 0.1:  # Ignore very close readings
                min_distance = distance
                min_index = i
        
        return min_index, min_distance
    
    def get_front_ray_index(self):
        """Get the index of the front laser ray"""
        if self.laser_data is None:
            return -1
        
        return int((0 - self.laser_data.angle_min) / self.laser_data.angle_increment)
    
    def get_ray_270_index(self):
        """Get the index of the 270-degree laser ray (right side)"""
        if self.laser_data is None:
            return -1
        
        return int((3 * math.pi / 2 - self.laser_data.angle_min) / self.laser_data.angle_increment) % len(self.laser_data.ranges)
    
    def rotate_to_front_smallest(self):
        """Rotate the robot until the front ray is the smallest"""
        if self.laser_data is None:
            return False
        
        rate = rospy.Rate(10)  # 10 Hz
        front_index = self.get_front_ray_index()
        
        # Rotate slowly
        self.vel_msg.linear.x = 0
        self.vel_msg.angular.z = 0.3  # Positive = left turn
        
        while not rospy.is_shutdown():
            if self.laser_data is None:
                continue
                
            shortest_index, _ = self.get_shortest_laser_ray()
            front_index = self.get_front_ray_index()
            
            # Check if front ray is now pointing to the closest wall
            # Allow a small margin of error
            if abs(shortest_index - front_index) < 5:
                # Stop rotating
                self.vel_msg.angular.z = 0
                self.velocity_publisher.publish(self.vel_msg)
                return True
            
            self.velocity_publisher.publish(self.vel_msg)
            rate.sleep()
        
        return False
    
    def move_forward_until_close(self):
        """Move forward until front ray is less than 30cm"""
        if self.laser_data is None:
            return False
        
        rate = rospy.Rate(10)  # 10 Hz
        
        # Move forward slowly
        self.vel_msg.linear.x = 0.2
        self.vel_msg.angular.z = 0
        
        while not rospy.is_shutdown():
            if self.laser_data is None:
                continue
                
            front_index = self.get_front_ray_index()
            if front_index >= 0 and front_index < len(self.laser_data.ranges):
                front_distance = self.laser_data.ranges[front_index]
                
                # Check if we're close enough to the wall
                if not math.isnan(front_distance) and front_distance < 0.3:
                    # Stop moving
                    self.vel_msg.linear.x = 0
                    self.velocity_publisher.publish(self.vel_msg)
                    return True
            
            self.velocity_publisher.publish(self.vel_msg)
            rate.sleep()
        
        return False
    
    def rotate_to_ray_270(self):
        """Rotate until ray 270 points to the wall"""
        if self.laser_data is None:
            return False
        
        rate = rospy.Rate(10)  # 10 Hz
        
        # Rotate slowly to the right
        self.vel_msg.linear.x = 0
        self.vel_msg.angular.z = -0.3  # Negative = right turn
        
        while not rospy.is_shutdown():
            if self.laser_data is None:
                continue
                
            ray_270_index = self.get_ray_270_index()
            
            if ray_270_index >= 0 and ray_270_index < len(self.laser_data.ranges):
                ray_270_distance = self.laser_data.ranges[ray_270_index]
                
                # Check if ray 270 is pointing to a wall
                # We assume it's pointing to a wall if it's detecting something within a reasonable distance
                if not math.isnan(ray_270_distance) and ray_270_distance < 1.0:
                    # Stop rotating
                    self.vel_msg.angular.z = 0
                    self.velocity_publisher.publish(self.vel_msg)
                    return True
            
            self.velocity_publisher.publish(self.vel_msg)
            rate.sleep()
        
        return False
    
    def handle_find_wall(self, request):
        """Handle the find_wall service request"""
        rospy.loginfo("Received request to find wall")
        
        # Check if we have laser data
        if self.laser_data is None:
            rospy.logwarn("No laser data available")
            return FindWallResponse(wallfound=False)
        
        # 1. Identify shortest laser ray
        shortest_index, shortest_distance = self.get_shortest_laser_ray()
        rospy.loginfo("Shortest laser ray: index=%d, distance=%.2f", shortest_index, shortest_distance)
        
        # 2. Rotate until front ray is smallest
        rospy.loginfo("Rotating until front ray faces the wall")
        if not self.rotate_to_front_smallest():
            rospy.logwarn("Failed to rotate to face wall")
            return FindWallResponse(wallfound=False)
        
        # 3. Move forward until front ray < 30cm
        rospy.loginfo("Moving forward until close to wall")
        if not self.move_forward_until_close():
            rospy.logwarn("Failed to move close to wall")
            return FindWallResponse(wallfound=False)
        
        # 4. Rotate until ray 270 points to wall
        rospy.loginfo("Rotating until ray 270 points to wall")
        if not self.rotate_to_ray_270():
            rospy.logwarn("Failed to position for wall following")
            return FindWallResponse(wallfound=False)
        
        rospy.loginfo("Successfully found and positioned for wall following")
        return FindWallResponse(wallfound=True)

if __name__ == '__main__':
    try:
        find_wall_server = FindWallServer()
        rospy.spin()
    except rospy.ROSInterruptException:
        pass