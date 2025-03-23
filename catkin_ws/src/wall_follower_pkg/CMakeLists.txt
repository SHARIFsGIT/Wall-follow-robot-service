cmake_minimum_required(VERSION 3.0.2)
project(wall_follower_pkg)

find_package(catkin REQUIRED COMPONENTS
  rospy
  std_msgs
  sensor_msgs
  geometry_msgs
  message_generation
  actionlib_msgs
  actionlib
)

add_service_files(
  FILES
  FindWall.srv
)

add_action_files(
  FILES
  OdomRecord.action
)

generate_messages(
  DEPENDENCIES
  std_msgs
  geometry_msgs
  actionlib_msgs
)

catkin_package(
  CATKIN_DEPENDS rospy std_msgs geometry_msgs actionlib_msgs message_runtime
)

catkin_install_python(PROGRAMS
  scripts/wall_follower.py
  scripts/find_wall_server.py
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)