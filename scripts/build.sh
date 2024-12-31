#!/usr/bin/env bash

# Source our utility functions for logging and output formatting.
source "$(dirname "$0")/utils.sh"

########################################
# Constants
########################################

# Default image and tag for the Kali Linux container.
KALI_IMAGE_DEFAULT="metasploit"   # Base name for the image.
KALI_TAG_DEFAULT="lab"            # Default tag for the image (latest by default).
KALI_IMAGE_TAG="${KALI_IMAGE_DEFAULT}:${KALI_TAG_DEFAULT}" # Combined image:tag string.

########################################
# Parse Command-Line Arguments
########################################
# Allows overriding the default image and tag via the --image flag.
while [[ $# -gt 0 ]]; do
  case "$1" in
    --image)
      KALI_IMAGE_TAG="$2"            # Set the image:tag string to the provided value.
      shift 2                        # Move past the flag and its value.
      ;;
    *)
      fancy_echo "Unknown option: $1" # Output a warning for unrecognized options.
      exit 1                         # Exit the script with an error code.
      ;;
  esac
done

########################################
# Build Docker Image
########################################
# Build the Docker image for the Kali Linux container.
# This uses the specified image:tag or the default if none was provided.
docker build -t "${KALI_IMAGE_TAG}" . # Build the image using the Dockerfile in the current directory.

# Notify the user that the build process has completed.
fancy_echo "Build complete for image: ${KALI_IMAGE_TAG}"