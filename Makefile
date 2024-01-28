# Makefile for ORB_SLAM3-Docker
#
# Usage(Currently no args):
#   make <target> <arg-name>=<arg-value>
#
# Examples:
#   make
#   make build-base

# Docker variables
IMAGE_NAME = ros1_ros2_overlay
ROS1_DOCKERFILE = ${PWD}/docker/dockerfile_ros1
ROS2_DOCKERFILE = ${PWD}/docker/dockerfile_ros2

# linux/arm64 for board, amd64 for pc
DEVICE_ARCH := $(shell dpkg --print-architecture)
ifeq ($(DEVICE_ARCH),arm64)
  DEVICE_ARCH := linux/arm64
endif

#############################################
#					SETUP  					#
#############################################
# Build the ros1 image
.PHONY: build-base
build-base:
	@docker build --platform ${DEVICE_ARCH} -f ${ROS1_DOCKERFILE} -t ros1_slam_base .

# Build the overlay image (depends on ros1 image build)
.PHONY: build-overlay
build-overlay: build-base
	@docker build --platform ${DEVICE_ARCH} -f ${ROS2_DOCKERFILE} -t ${IMAGE_NAME} .

# Kill any running Docker containers
.PHONY: kill
kill:
	@echo "Closing all running Docker containers:"
	@docker kill $(shell docker ps -q --filter ancestor=${IMAGE_NAME})

# Build all targets if not specified
.DEFAULT_GOAL := all
all: build-base build-overlay kill

#############################################
#					TASKS  					#
#############################################
.PHONY: slam_docker
slam_docker:
	@echo "---STARTING DOCKER CONTAINER---\n"
	@xhost +local:root &> /dev/null
	@docker run -it \
		--privileged \
		--net=host \
		--gpus all \
		--env=NVIDIA_VISIBLE_DEVICES=all \
		--env=NVIDIA_DRIVER_CAPABILITIES=all \
		--env=DISPLAY \
		--env=QT_X11_NO_MITSHM=1 \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v ${PWD}/ROS/:/root/ROS/ \
		${IMAGE_NAME}:latest\
		/bin/bash