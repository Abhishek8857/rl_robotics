#!/bin/bash

# Allow X11 Connections for GUI support
xhost +local:docker

# List all the directory paths
SCRIPT_DIR="$(dirname $(readlink -f $0))"
REPO_DIR="$(realpath "${SCRIPT_DIR}/..")"
PARENT_DIR="$(realpath "${REPO_DIR}/..")"

# Docker run code
docker run --name isaac-sim --entrypoint bash -it --runtime=nvidia --gpus all -e "ACCEPT_EULA=Y" --network=host \
    --rm \
    --pid=host \
    --ipc=host \
    --privileged \
    -e OMNI_KIT_ALLOW_ROOT=1 \
    -e DISPLAY=$DISPLAY \
    -v /dev:/dev \
    -e XDG_SESSION_TYPE=x11 \
    -e QT_X11_NO_MITSHM=1 \
    -e RESOURCE_NAME="IsaacSim" \
    -v $HOME/.ros/log:/.ros/log \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -e "PRIVACY_CONSENT=Y" \
    -v ~/docker/isaac-sim/data:/root/.local/share/ov:rw \
    -v ~/docker/isaac-sim/cache/ov:/root/.cache/ov:rw \
    -v ~/docker/isaac-sim/logs:/root/.nvidia-omniverse/logs:rw \
    -v ~/docker/isaac-sim/cache/kit:/isaac-sim/kit/cache:rw \
    -v ~/docker/isaac-sim/cache/ov:/root/.cache/ov:rw \
    -v ~/docker/isaac-sim/cache/pip:/root/.cache/pip:rw \
    -v ~/docker/isaac-sim/cache/glcache:/root/.cache/nvidia/GLCache:rw \
    -v ~/docker/isaac-sim/cache/computecache:/root/.nv/ComputeCache:rw \
    -v ~/docker/isaac-sim/logs:/root/.nvidia-omniverse/logs:rw \
    -v ~/docker/isaac-sim/data:/root/.local/share/ov/data:rw \
    -v ~/docker/isaac-sim/documents:/root/Documents:rw \
    -v ~/docker/isaac-sim/omniverse:/root/.nvidia-omniverse/omniverse:rw \
    -v ~/docker/isaac-sim/config-ov:/root/.config/ov:rw \
    -v "$REPO_DIR:/rl_robotics:rw" \
    -v $PARENT_DIR:/root/workspaces/thesis_ws:rw \
    rl-robotics \
    /entrypoint_scripts/entrypoint_docker_run.sh
