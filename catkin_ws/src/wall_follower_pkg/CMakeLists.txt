cmake_minimum_required(VERSION 3.0.2)
project(wall_follower_pkg)

find_package(catkin REQUIRED COMPONENTS
  rospy
  std_msgs
  sensor_msgs
  geometry_msgs
  message_generation
)

add_service_files(
  FILES
  FindWall.srv
)

generate_messages(
  DEPENDENCIES
  std_msgs
)

catkin_package(
  CATKIN_DEPENDS message_runtime rospy std_msgs
)

include_directories(
  ${catkin_INCLUDE_DIRS}
)

catkin_install_python(PROGRAMS
  scripts/wall_follower.py
  scripts/find_wall_server.py
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)