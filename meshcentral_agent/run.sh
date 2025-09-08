#!/bin/sh
# run.sh
set -e

MESH_SERVER_URL=$(jq --raw-output '.mesh_server_url' /data/options.json)
MESH_INSTALL_TOKEN=$(jq --raw-output '.mesh_install_token' /data/options.json)

if [ -z "$MESH_SERVER_URL" ] || [ -z "$MESH_INSTALL_TOKEN" ]; then
    echo "ERROR: Server URL or install token not configured. Please check add-on options."
    exit 1
fi

AGENT_PATH="/data/meshagent"
CONFIG_DIR="/data/meshagent_data"
MSH_FILE="$AGENT_PATH.msh"

# Create config dir
mkdir -p "$CONFIG_DIR"

if [ ! -f "$AGENT_PATH" ]; then
    echo "MeshCentral Agent not found. Starting first-time setup..."

    arch=$(uname -m)
    machine_id=""
    case "$arch" in
      x86_64) machine_id="6" ;; # Linux x86 64 bit
      aarch64) machine_id="26" ;; # RaspberryPi 3B+/4/5 64 bit
      armv7l) machine_id="25" ;; # RaspberryPi 2/3 32 bit
      armv6l) machine_id="25" ;; # RaspberryPi 1 32 bit
      *)
        echo "Unsupported architecture: $arch"
        exit 1
        ;;
    esac
    
    echo "Downloading MeshCentral Agent from $MESH_SERVER_URL"
    wget "$MESH_SERVER_URL/meshagents?id=$machine_id" -O "$AGENT_PATH" || curl -L --output "$AGENT_PATH" "$MESH_SERVER_URL/meshagents?id=$machine_id"

    if [ $? -ne 0 ]; then
        echo "Failed to download MeshAgent."
        exit 1
    fi

    echo "Downloading device group settings..."
    wget "$MESH_SERVER_URL/meshsettings?id=$MESH_INSTALL_TOKEN" -O "$MSH_FILE" || curl -L --output "$MSH_FILE" "$MESH_SERVER_URL/meshsettings?id=$MESH_INSTALL_TOKEN"
    
    if [ $? -ne 0 ]; then
        echo "Failed to download settings file."
        exit 1
    fi

    echo "Initial setup complete."
fi

echo "Starting MeshCentral Agent..."
chmod +x "$AGENT_PATH"

# settings file .msh
MESH_SERVICE_NAME="meshcentral_agent"
if [ -f "$MSH_FILE" ]; then
    SERVICE_NAME=$(grep -i "^meshServiceName=" "$MSH_FILE" | cut -d'=' -f2)
    if [ -n "$SERVICE_NAME" ]; then
        MESH_SERVICE_NAME="$SERVICE_NAME"
        echo "Using service name from config: $MESH_SERVICE_NAME"
    fi
fi

# STARTING AGENT
"$AGENT_PATH" -statedir "$CONFIG_DIR" --meshServiceName="$MESH_SERVICE_NAME" --installedByUser=0

tail -f /dev/null