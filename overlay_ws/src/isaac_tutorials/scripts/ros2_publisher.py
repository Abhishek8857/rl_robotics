#!/usr/bin/env python3

# Copyright (c) 2020-2022, NVIDIA CORPORATION.  All rights reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

import rclpy
from rclpy.node import Node
from sensor_msgs.msg import JointState
import numpy as np
import time


class TestROS2Bridge(Node):
    def __init__(self):

        super().__init__("test_ros2bridge")

        # Create the publisher. This publisher will publish a JointState message to the /joint_command topic.
        self.publisher_ = self.create_publisher(JointState, "isaac_joint_command", 10)

        # Create a JointState message
        self.joint_state = JointState()

        self.joint_state.name = [
            "joint_1",
            "joint_2",
            "joint_3",
            "joint_4",
            "joint_5",
            "joint_6",
            "joint_7",
            "finger_joint",
        ]

        num_joints = len(self.joint_state.name)

        # Kinova Gen3 home position (all zeros is a common safe home position)
        self.default_joints = [0.0, 0.26, 0.0, 2.1, 0.0, 0.9, 1.57, 00.5]
        
        # Set the joint state to the home position
        self.joint_state.position = self.default_joints

        timer_period = 0.05  # seconds
        self.timer = self.create_timer(timer_period, self.timer_callback)

    def timer_callback(self):
        self.joint_state.header.stamp = self.get_clock().now().to_msg()

        # Publish the home position continuously
        self.publisher_.publish(self.joint_state)
        print("Publishing home position:", self.joint_state.position)


def main(args=None):
    rclpy.init(args=args)

    ros2_publisher = TestROS2Bridge()

    rclpy.spin(ros2_publisher)

    # Destroy the node explicitly
    ros2_publisher.destroy_node()
    rclpy.shutdown()


if __name__ == "__main__":
    main()