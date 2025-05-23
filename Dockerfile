# Base image: NVIDIA's Isaac Sim 4.5
FROM nvcr.io/nvidia/isaac-sim:4.5.0

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    ACCEPT_EULA=Y \
    ROS_DISTRO=humble \
    ISAACLAB_PATH=/lab_workspace/IsaacLab \
    ROS_DOMAIN_ID=0 \
    LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:/usr/local/lib

# Install dependencies and add ROS 2 apt key and source
RUN apt-get update && \
    apt-get install -y curl gnupg2 lsb-release locales sudo git wget python3-pip && pip3 install -U colcon-common-extensions && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | gpg --dearmor -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/ros2.list && rm -rf /var/lib/apt/lists/*

# Install ROS 2 Humble
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-humble-ros-base \
    ros-humble-vision-msgs \
    ros-humble-ackermann-msgs \
    python3-rosdep \
    python3-rosinstall \
    python3-rosinstall-generator \
    python3-wstool \
    build-essential \
    python3-colcon-common-extensions \
    && rm -rf /var/lib/apt/lists/*

# Update pip
RUN pip install --upgrade pip 

# Install Python packages for RL
RUN pip install torch==2.5.1 torchvision==0.20.1 --index-url https://download.pytorch.org/whl/cu121
    # 'isaacsim[all,extscache]==4.5.0' -extra-index-url https://pypi.nvidia.com


# Default command
SHELL ["/bin/bash", "-c"]
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc

# Set Environment Variables
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp \
    AMENT_PREFIX_PATH=/opt/ros/humble \
    LD_LIBRARY_PATH=/isaac-sim/exts/isaacsim.ros2.bridge/humble/lib:$LD_LIBRARY_PATH

# Copy entrypoint scripts and make them executable
COPY entrypoint_scripts/ /entrypoint_scripts/
RUN chmod +x /entrypoint_scripts/*.sh

WORKDIR /isaac-sim

CMD ["/bin/bash"]
