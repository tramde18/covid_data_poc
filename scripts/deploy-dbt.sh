#!/bin/bash

export CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DBT_PROFILES_DIR="${CURRENT_DIR}/dbt"
export DBT_PROJECT_DIR="$(dirname "$CURRENT_DIR")/dbt"

# Debugging Purposes
echo $CURRENT_DIR
echo $DBT_PROFILES_DIR
echo $DBT_PROJECT_DIR

dbt run --profiles-dir="${DBT_PROFILES_DIR}" --target $1 --models ${2}
