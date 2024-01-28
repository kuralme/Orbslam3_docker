#!/bin/bash
# Basic entrypoint for ROS1 / ROS2 Docker containers

# Source ROS and Catkin workspaces
source /opt/ros/noetic/setup.bash
if [ -f /ROS/ros1_ws/devel/setup.bash ]
then
  echo "source /ROS/ros1_ws/devel/setup.bash" >> ~/.bashrc
  source /ROS/ros1_ws/devel/setup.bash
fi

# Source ROS2 and Colcon workspaces
source /opt/ros/foxy/setup.bash
if [ -f /ROS/ros2_ws/devel/setup.bash ]
then
  echo "source /ROS/ros2_ws/devel/setup.bash" >> ~/.bashrc
  source /ROS/ros2_ws/devel/setup.bash
fi
echo "Sourced ROS1 & ROS2 workspaces!"

# Set environment variables
export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:/root/ROS/ros1_ws/src/ORB_SLAM3/Examples/ROS

# Execute the command passed into this entrypoint
exec "$@"