# Base image: NVIDIA's Isaac Sim 4.5
FROM nvcr.io/nvidia/isaac-sim:4.5.0

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    ACCEPT_EULA=Y \
    ROS_DISTRO=humble \
    ISAACLAB_PATH=/workspace/IsaacLab \
    ROS_DOMAIN_ID=0


# Install dependencies and add ROS 2 apt key and source
RUN apt-get update && \
    apt-get install -y curl gnupg2 lsb-release && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | gpg --dearmor -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/ros2.list

# Install dependencies
RUN apt-get install -y --no-install-recommends \
    locales \
    sudo \
    git \
    wget \
    python3-pip && \
    pip3 install -U colcon-common-extensions \
    && rm -rf /var/lib/apt/lists/*

# Install ROS 2 Humble
RUN apt-get update && apt-get install -y --no-install-recommends \
ros-humble-ros-base \
&& rm -rf /var/lib/apt/lists/*

# Source ROS 2 setup script
SHELL ["/bin/bash", "-c"]
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc

# Install Python packages for RL
RUN pip3 install --upgrade pip && \
    pip3 install \
    torch==2.0.1 \
    torchvision==0.15.2 \
    torchaudio==2.0.2 \
    stable-baselines3==2.0.0 \
    tensorboard \
    gym==0.26.2 \
    matplotlib \
    numpy \
    pandas \
    scipy \
    scikit-learn


# Default command
SHELL ["/bin/bash", "-c"]
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
