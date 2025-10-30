#!/bin/bash

PUID=${PUID:-1000}
PGID=${PGID:-1000}
USER_NAME="appuser"
USER_HOME="/home/${USER_NAME}"
COMFY="/comfyui"
COMFY_GIT="https://github.com/comfyanonymous/ComfyUI.git"

# 檢查新的環境變數 COMFY_MODE，預設為 'single' (單人)
COMFY_MODE=${COMFY_MODE:-single}
RUN_ARGS="--listen 0.0.0.0 --port 8188"

# Check if ComfyUI is installed
if [ -f "${COMFY}/main.py" ]; then
  echo "ComfyUI is already installed."
else
  echo "ComfyUI not found, installing..."
  git clone ${COMFY_GIT} ${COMFY}
fi

# Single or Multi user
if [ "$COMFY_MODE" = "multi" ]; then
    RUN_ARGS="${RUN_ARGS} --multi-user"
    echo "Starting ComfyUI in MULTI-USER mode."
else
    echo "Starting ComfyUI in SINGLE-USER mode."
fi

# Set permissions for the /comfyui directory
chown -R ${PUID}:${PGID} ${COMFY}

# Start the ComfyUI service as APPUSER
exec gosu ${PUID}:${PGID} python -u ${COMFY}/main.py ${RUN_ARGS}
