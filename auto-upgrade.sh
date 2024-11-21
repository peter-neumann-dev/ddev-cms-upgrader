#!/bin/bash

# Exit on error
set -e

# Read .env file (adjust path if needed)
source ./build/.env

CMS_TYPE=${CMS_TYPE}
VERSIONS=(${CMS_VERSIONS})

# Get last version to upgrade to
LAST_VERSION=${VERSIONS[@]: -1}
FIRST_VERSION=${VERSIONS[@]: 0:1}

# Create tmp directory if not exists (adjust path if needed)
echo "Create tmp directory if not exists ..."
TEMP_FOLDER="./build/tmp"
mkdir -p ${TEMP_FOLDER}

hr () {
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
}

# Loop through versions and upgrade step by step
for version in "${VERSIONS[@]}"; do

    echo "Checkout ${version} branch ..."
    git checkout ${CMS_TYPE}-${version} | tee ${TEMP_FOLDER}/${CMS_TYPE}-log-${version}.log

    if [ "${version}" == "${FIRST_VERSION}" ];
      then
        echo "Start DDEV first time, maybe import db automatically ..."
        echo "Use DDEV's provider to get and import db. https://ddev.readthedocs.io/en/stable/users/providers/"
        ddev warmup | tee -a ./tmp/${CMS_TYPE}-log-${version}.log
        ddev upgrade | tee -a ./tmp/${CMS_TYPE}-log-${version}.log
      else
        echo "Start DDEV ..."
        ddev warmup | tee -a ./tmp/${CMS_TYPE}-log-${version}.log
        ddev upgrade | tee -a ./tmp/${CMS_TYPE}-log-${version}.log
    fi

    # If not last version, stop DDEV and continue with next version
    if [ "${version}" != "${LAST_VERSION}" ];
      then
        echo "DDEV Stop ..."
        ddev stop
      else
        hr
        echo "Upgrade finished!" | tee -a ${TEMP_FOLDER}/${CMS_TYPE}-log-${version}.log
        hr
    fi
done
