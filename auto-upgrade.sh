#!/bin/bash

# Exit on error
set -e

# Read .env file (adjust path if needed)
source ./.env

CMS_TYPE=${CMS_TYPE}
VERSIONS=(${CMS_VERSIONS})

# Get last version to upgrade to
LAST_VERSION=${VERSIONS[@]: -1}

# Create tmp directory if not exists (adjust path if needed)
echo "Create tmp directory if not exists ..."
mkdir -p ./tmp

# Loop through versions and upgrade step by step
for version in "${VERSIONS[@]}"; do

    echo "Checkout ${version} branch ..."
    git checkout ${CMS_TYPE}-${version} | tee ./tmp/${CMS_TYPE}-log-${version}.log

    echo "Start DDEV ..."
    ddev start | tee ./tmp/${CMS_TYPE}-log-${version}.log

    # If not last version, stop DDEV and continue with next version
    if [ "${version}" != "${LAST_VERSION}" ];
        then
            echo "DDEV Stop ..."
            ddev stop
        else
            echo "Upgrade finished!"
    fi
done
