#!/bin/bash

# Set variables
IMAGE_NAME="swift-vapor-build"
CONTAINER_NAME="swift-vapor-container"
ZIP_FILE="bootstrap.zip"

# Step 1: Build the Docker image
docker build --target build -t $IMAGE_NAME .

# Step 2: Create a temporary container from the build stage
docker create --name $CONTAINER_NAME $IMAGE_NAME

# Step 3: Copy the executable out of the container
docker cp $CONTAINER_NAME:/staging/App ./bootstrap

# Step 4: Package the executable into bootstrap.zip
zip $ZIP_FILE bootstrap

# Step 5: Clean up the container
docker rm $CONTAINER_NAME

# Optional: Clean up the Docker image if no longer needed
docker rmi $IMAGE_NAME

# Step 7: Remove the copied executable
rm bootstrap

# Step 8: Move it to the infrastructure folder
mv $ZIP_FILE ../../infrastructure

echo "Build and packaging complete. The ZIP file is located at $ZIP_FILE"
