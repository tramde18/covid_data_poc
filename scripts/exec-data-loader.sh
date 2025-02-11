#!/bin/bash

export CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DATA_LOADER_CONFIG_PATH="${CURRENT_DIR}/data_loader/config/settings.yml"
export DATA_LOADER_EXEC_FILE="$(dirname "$CURRENT_DIR")/utils/main.py"

# Debugging Purposes
echo $CURRENT_DIR
echo $DATA_LOADER_CONFIG_PATH
echo $DATA_LOADER_EXEC_FILE

python $DATA_LOADER_EXEC_FILE