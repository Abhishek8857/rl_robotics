#!/bin/bash
set -e

CONTAINER_NAME=$(cat image_name.cfg)

# Build the Docker image and pass the boolean
docker build -t "$CONTAINER_NAME" .