#!/usr/bin/env python

import rospy
import actionlib
import math
from nav_msgs.msg import Odometry
from geometry_msgs.msg import Point32
from wall_follower_pkg.msg import OdomRecordAction, OdomRecordResult, OdomRecordFeedback

class RecordOdomServer:
    def __init__(self):
        # Initialize the node
        rospy.init_node('record_odom_server')
        
        # Create the action server
        self.server = actionlib.SimpleActionServer('record_odom', OdomRecordAction, self.execute, False)
        
        # Subscribe to odometry topic
        self.odom_subscriber = rospy.Subscriber('/odom', Odometry, self.odom_callback)
        
        # Initialize variables
        self.odom_list = []
        self.current_position = None
        self.previous_position = None
        self.total_distance = 0.0
        
        # Start the server
        self.server.start()
        rospy.loginfo("Record Odometry Action Server started")
    
    def odom_callback(self, data):
        """Store current position from odometry data"""
        self.current_position = data.pose.pose
    
    def execute(self, goal):
        """Execute the action when called by a client"""
        rospy.loginfo("Starting to record odometry")
        
        # Reset variables for new recording
        self.odom_list = []
        self.total_distance = 0.0
        self.previous_position = None
        
        # Create feedback and result messages
        feedback = OdomRecordFeedback()
        result = OdomRecordResult()
        
        # Record at 1 Hz
        rate = rospy.Rate(1)
        
        while not rospy.is_shutdown() and not self.server.is_preempt_requested():
            if self.current_position is not None:
                # Create a Point32 to store position
                point = Point32()
                point.x = self.current_position.position.x
                point.y = self.current_position.position.y
                
                # Calculate theta (orientation) from quaternion
                # This is a simplified conversion assuming mainly 2D motion
                qx = self.current_position.orientation.x
                qy = self.current_position.orientation.y
                qz = self.current_position.orientation.z
                qw = self.current_position.orientation.w
                
                # Simplified conversion from quaternion to Euler angle for yaw
                # point.z will store the theta value
                point.z = math.atan2(2.0 * (qw * qz + qx * qy), 1.0 - 2.0 * (qy * qy + qz * qz))
                
                # Add point to list
                self.odom_list.append(point)
                
                # Calculate distance traveled since last point
                if self.previous_position is not None:
                    dx = self.current_position.position.x - self.previous_position.position.x
                    dy = self.current_position.position.y - self.previous_position.position.y
                    distance = math.sqrt(dx*dx + dy*dy)
                    self.total_distance += distance
                
                # Update previous position
                self.previous_position = self.current_position
                
                # Send feedback with total distance
                feedback.current_total = self.total_distance
                self.server.publish_feedback(feedback)
                
                # Check if we've completed a lap (returned close to the starting point)
                if len(self.odom_list) > 10:  # Ensure we have enough points
                    start_point = self.odom_list[0]
                    current_point = point
                    
                    # Calculate distance to starting point
                    dx = current_point.x - start_point.x
                    dy = current_point.y - start_point.y
                    distance_to_start = math.sqrt(dx*dx + dy*dy)
                    
                    # If we're close to the starting point and have moved a significant distance
                    if distance_to_start < 0.5 and self.total_distance > 1.0:
                        rospy.loginfo("Lap completed! Returning recorded odometry.")
                        result.list_of_odoms = self.odom_list
                        self.server.set_succeeded(result)
                        return
            
            rate.sleep()
        
        # If preempted, return what we have
        if self.server.is_preempt_requested():
            rospy.loginfo("Action preempted")
            result.list_of_odoms = self.odom_list
            self.server.set_preempted(result)
        else:
            result.list_of_odoms = self.odom_list
            self.server.set_succeeded(result)

if __name__ == '__main__':
    try:
        server = RecordOdomServer()
        rospy.spin()
    except rospy.ROSInterruptException:
        pass