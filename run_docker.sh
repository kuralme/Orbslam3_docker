#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

if (docker ps --all | grep -q orbslam3_docker)
then
    printf "${GREEN}---DOCKER CONTAINER IS VALID---\n${NC}"
    xhost +local:root &> /dev/null
    # If Docker is already running, no need to start it
    if (docker ps | grep -q orbslam3_docker)
    then
        printf "${YELLOW}---OPENNING DOCKER CONTAINER---\n${NC}"
        docker exec -it orbslam3_docker /bin/bash && \
        xhost -local:root 1>/dev/null 2>&1
    else
        printf "${YELLOW}---STARTING DOCKER CONTAINER---\n${NC}"
        docker start orbslam3_docker 1>/dev/null 2>&1
        docker exec -it orbslam3_docker /bin/bash && \
        xhost -local:root 1>/dev/null 2>&1
    fi
else
    printf "${RED}---CREATING DOCKER CONTAINER---\n${NC}"
    xhost +local:root &> /dev/null
    docker run \
        -it \
        --privileged \
        --net=host \
        --gpus all \
        --env=NVIDIA_VISIBLE_DEVICES=all \
        --env=NVIDIA_DRIVER_CAPABILITIES=all \
        --env=DISPLAY \
        --env=QT_X11_NO_MITSHM=1 \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v ${PWD}/ROS/:/root/ROS/ \
        --name orbslam3_docker \
        ros1_ros2_overlay:latest \
        /bin/bash
fi
