#!/usr/bin/env bash

# Source our utility
source "$(dirname "$0")/utils.sh"

########################################
# Constants
########################################
NETWORK_NAME="vnet"

DVWA_CONTAINER_NAME="dvwa"
DVWA_HOSTNAME="dvwa"
DVWA_IMAGE="vulnerables/web-dvwa"
DVWA_PORT_MAPPING="8080:80"

JUICE_CONTAINER_NAME="juice"
JUICE_HOSTNAME="juice"
JUICE_IMAGE="bkimminich/juice-shop"
JUICE_PORT_MAPPING="3000:3000"

KALI_CONTAINER_NAME="kalibox"
KALI_HOSTNAME="attacker"

# Default image:tag
KALI_IMAGE_DEFAULT="b1-metasploit"
KALI_TAG_DEFAULT="latest"
KALI_IMAGE_TAG="${KALI_IMAGE_DEFAULT}:${KALI_TAG_DEFAULT}"

########################################
# Parse Arguments
########################################
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

########################################
# Create Network if Needed
########################################
if ! docker network ls | grep -q "${NETWORK_NAME}"; then
  fancy_echo "Network '${NETWORK_NAME}' does not exist. Creating it now..."
  docker network create "${NETWORK_NAME}"
  fancy_echo "Network '${NETWORK_NAME}' created successfully."
else
  fancy_echo "Network '${NETWORK_NAME}' already exists."
fi

########################################
# Start DVWA
########################################
docker run \
  --network="${NETWORK_NAME}" \
  -h "${DVWA_HOSTNAME}" \
  -d \
  --rm \
  -p "${DVWA_PORT_MAPPING}" \
  --name "${DVWA_CONTAINER_NAME}" \
  "${DVWA_IMAGE}"

fancy_echo "Started DVWA on port ${DVWA_PORT_MAPPING} (host:container)."

########################################
# Start Juice Shop
########################################
docker run \
  --network="${NETWORK_NAME}" \
  -h "${JUICE_HOSTNAME}" \
  -d \
  --rm \
  -p "${JUICE_PORT_MAPPING}" \
  --name "${JUICE_CONTAINER_NAME}" \
  "${JUICE_IMAGE}"

fancy_echo "Started Juice Shop on port ${JUICE_PORT_MAPPING} (host:container)."

########################################
# Start Kali Box
########################################
fancy_echo "Starting Kali box (${KALI_IMAGE_TAG}) interactively..."
docker run \
  --network="${NETWORK_NAME}" \
  -h "${KALI_HOSTNAME}" \
  -it \
  --rm \
  --name "${KALI_CONTAINER_NAME}" \
  "${KALI_IMAGE_TAG}"

########################################
# Cleanup
########################################
fancy_echo "Cleaning up target containers..."
docker stop "${DVWA_CONTAINER_NAME}" "${JUICE_CONTAINER_NAME}"
fancy_echo "Target containers cleaned up successfully."