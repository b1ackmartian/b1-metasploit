#!/usr/bin/env bash

# Source our utility
source "$(dirname "$0")/utils.sh"

########################################
# Constants
########################################

# Default image:tag
KALI_IMAGE_DEFAULT="b1-metasploit"
KALI_TAG_DEFAULT="latest"
KALI_IMAGE_TAG="${KALI_IMAGE_DEFAULT}:${KALI_TAG_DEFAULT}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --image)
      KALI_IMAGE_TAG="$2"
      shift 2
      ;;
    *)
      fancy_echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

docker build -t "${KALI_IMAGE_TAG}" .
fancy_echo "Build complete for image: ${KALI_IMAGE_TAG}"