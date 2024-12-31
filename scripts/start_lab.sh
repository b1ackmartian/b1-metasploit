#!/usr/bin/env bash

# Source our utility functions for logging and echoing messages.
source "$(dirname "$0")/utils.sh"

########################################
# Constants
########################################
# Define reusable constants for container and network configuration.
NETWORK_NAME="vnet"                  # Virtual network name.

DVWA_CONTAINER_NAME="dvwa"           # Container name for DVWA.
DVWA_HOSTNAME="dvwa"                 # Hostname for DVWA container.
DVWA_IMAGE="vulnerables/web-dvwa"    # Image to use for the DVWA container.
DVWA_PORT_MAPPING="8080:80"          # Port mapping for DVWA (host:container).

JUICE_CONTAINER_NAME="juice"         # Container name for Juice Shop.
JUICE_HOSTNAME="juice"               # Hostname for Juice Shop container.
JUICE_IMAGE="bkimminich/juice-shop"  # Image to use for the Juice Shop container.
JUICE_PORT_MAPPING="3000:3000"       # Port mapping for Juice Shop (host:container).

KALI_CONTAINER_NAME="kalibox"        # Container name for Kali Linux.
KALI_HOSTNAME="attacker"             # Hostname for Kali container.

# Default image and tag for the Kali Linux container.
KALI_IMAGE_DEFAULT="metasploit"   # Default image name for Kali.
KALI_TAG_DEFAULT="lab"            # Default tag for the Kali image.
KALI_IMAGE_TAG="${KALI_IMAGE_DEFAULT}:${KALI_TAG_DEFAULT}" # Full image:tag string.

########################################
# Parse Arguments
########################################
# Parse command-line arguments to override defaults.
while [[ $# -gt 0 ]]; do
  case "$1" in
    --image)
      KALI_IMAGE_TAG="$2"            # Override the Kali image:tag with the provided value.
      shift 2                        # Move to the next set of arguments.
      ;;
    *)
      fancy_echo "Unknown option: $1" # Print an error for unrecognized options.
      exit 1                         # Exit the script with an error code.
      ;;
  esac
done

########################################
# Create Network if Needed
########################################
# Check if the virtual network exists; if not, create it.
if ! docker network ls | grep -q "${NETWORK_NAME}"; then
  fancy_echo "Network '${NETWORK_NAME}' does not exist. Creating it now..."
  docker network create "${NETWORK_NAME}" # Create the virtual network.
  fancy_echo "Network '${NETWORK_NAME}' created successfully."
else
  fancy_echo "Network '${NETWORK_NAME}' already exists." # Inform that the network is already available.
fi

########################################
# Start DVWA
########################################
# Start the DVWA container for testing web vulnerabilities.
docker run \
  --network="${NETWORK_NAME}" \      # Connect the DVWA container to the virtual network.
  -h "${DVWA_HOSTNAME}" \            # Set the hostname of the DVWA container.
  -d \                               # Run the container in detached mode.
  --rm \                             # Automatically remove the container when stopped.
  -p "${DVWA_PORT_MAPPING}" \        # Map the host port to the container port.
  --name "${DVWA_CONTAINER_NAME}" \  # Name the container for easy identification.
  "${DVWA_IMAGE}"                    # Specify the image to use.

fancy_echo "Started DVWA on port ${DVWA_PORT_MAPPING} (host:container)."

########################################
# Start Juice Shop
########################################
# Start the Juice Shop container for testing modern application vulnerabilities.
docker run \
  --network="${NETWORK_NAME}" \      # Connect the Juice Shop container to the virtual network.
  -h "${JUICE_HOSTNAME}" \           # Set the hostname of the Juice Shop container.
  -d \                               # Run the container in detached mode.
  --rm \                             # Automatically remove the container when stopped.
  -p "${JUICE_PORT_MAPPING}" \       # Map the host port to the container port.
  --name "${JUICE_CONTAINER_NAME}" \ # Name the container for easy identification.
  "${JUICE_IMAGE}"                   # Specify the image to use.

fancy_echo "Started Juice Shop on port ${JUICE_PORT_MAPPING} (host:container)."

########################################
# Start Kali Box
########################################
# This section starts the Kali Linux container interactively.
# The Kali box is the "attacker" in this lab setup, used to simulate penetration testing.
# NET_RAW and NET_ADMIN capabilities are added to enable network tools like nmap to function properly.

fancy_echo "Starting Kali box (${KALI_IMAGE_TAG}) interactively..."

docker run \
  --network="${NETWORK_NAME}" \      # Connects the Kali container to the specified virtual network (vnet).
  -h "${KALI_HOSTNAME}" \            # Sets the hostname of the container to 'attacker'.
  -it \                              # Runs the container interactively with a terminal.
  --rm \                             # Ensures the container is automatically removed after it stops.
  --name "${KALI_CONTAINER_NAME}" \  # Names the container 'kalibox' for easy reference.
  --cap-add=NET_RAW \                # Grants raw socket access, required for tools like ping, traceroute, and nmap.
  --cap-add=NET_ADMIN \              # Grants network administrative privileges for advanced configurations.
  "${KALI_IMAGE_TAG}"                # Specifies the Kali Linux image and tag to use.

########################################
# Cleanup
########################################
# Stop and clean up the target containers to reset the lab environment.
fancy_echo "Cleaning up target containers..."
docker stop "${DVWA_CONTAINER_NAME}" "${JUICE_CONTAINER_NAME}" # Stop the DVWA and Juice Shop containers.
fancy_echo "Target containers cleaned up successfully."