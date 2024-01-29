# ROS1+ROS2 Overlay environment for ORB SLAM3

[ORBSLAM3](https://github.com/kuralme/ORB_SLAM3_fix) is built inside Docker container and a ros2 wrapped repo added for [ros2](https://github.com/curryc/ros2_orbslam3.git) execution.

Tested on Ubuntu Linux 22.04.

## Install

The image is built using gnu make. Simply run:
```
make
```

Start the container
```
bash run_docker.sh
```
*Note:* Nvidia container toolkit required to run with the script.
## Issues
- Currently, cannot build the wrapper.
