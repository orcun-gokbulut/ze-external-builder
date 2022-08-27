#!/bin/bash

# Copyright (C) 2022 Y. Orçun GÖKBULUT <orcun.gokbulut@gmail.com>
# All rights reserved. 


ZE_BUILDER_ROOT_DIR_TEMP="$(dirname "$BASH_SOURCE")"
ZE_BUILDER_ROOT_DIR="$(realpath -m "$ZE_BUILDER_ROOT_DIR_TEMP")"
ZE_PACKAGES_ROOT_DIR="$ZE_ROOT_DIR/packages"

ZE_MODULE_NAME="Core"

source "$ZE_BUILDER_ROOT_DIR/log.sh"
source "$ZE_BUILDER_ROOT_DIR/common.sh"
source "$ZE_BUILDER_ROOT_DIR/arguments.sh"
source "$ZE_BUILDER_ROOT_DIR/packages.sh"
source "$ZE_BUILDER_ROOT_DIR/package-defaults.sh"
source "$ZE_BUILDER_ROOT_DIR/cmake.sh"

ze_arguments_parse $@
ze_log_initialize

ze_info "Zinek Engine External Builder - Version: $ZE_VERSION"
ze_info "----------------------------------------------------------"

for CURRENT in "${ZE_INCLUDED[@]}" ; do
    ZE_INCLUDED_STR+="$CURRENT "
done

for CURRENT in "${ZE_EXCLUDED[@]}" ; do
    ZE_EXCLUDED_STR+="$CURRENT "
done

ze_detail "ZE_ROOT_DIR = $ZE_ROOT_DIR"
ze_detail "ZE_BUILDER_ROOT_DIR = $ZE_BUILDER_ROOT_DIR"
ze_detail "ZE_SCRIPT_PATH = $ZE_SCRIPT_PATH"
ze_detail "ZE_SCRIPT_FILENAME = $ZE_SCRIPT_FILENAME"
ze_detail "ZE_STRING = $ZE_STRING"
ze_detail "ZE_PLATFORM = $ZE_PLATFORM"
ze_detail "ZE_ARCHITECTURE = $ZE_ARCHITECTURE"
ze_detail "ZE_TOOLCHAIN = $ZE_TOOLCHAIN"
ze_detail "ZE_BUILD_TYPE = $ZE_BUILD_TYPE"
ze_detail "ZE_SOURCE_DIR = $ZE_SOURCE_DIR"
ze_detail "ZE_BINARY_DIR = $ZE_BINARY_DIR"
ze_detail "ZE_OUTPUT_DIR = $ZE_OUTPUT_DIR"
ze_detail "ZE_LOG_DIR = $ZE_LOG_DIR"
ze_detail "ZE_LOG_FILE = $ZE_LOG_FILE"
ze_detail "ZE_SEPARATE_LOG_FILES = $ZE_SEPARATE_LOG_FILES"
ze_detail "ZE_FILTER_MODE = $ZE_FILTER_MODE"
ze_detail "ZE_INCLUDED = $ZE_INCLUDED_STR"
ze_detail "ZE_EXCLUDED = $ZE_EXCLUDED_STR"
ze_detail "ZE_QUIET =  $ZE_QUIET"
ze_detail "ZE_VERBOSE = $ZE_VERBOSE"
ze_detail "ZE_DEBUG = $ZE_DEBUG"
ze_detail "ZE_OPERATION = $ZE_OPERATION"


case "$ZE_OPERATION" in
    compile)
        mkdir -p $ZE_BINARY_DIR
        mkdir -p $ZE_OUTPUT_DIR
        ;;
    bootstrap)
        sudo apt-get update
        sudo apt-get install -y \
            build-essential \
            cmake \
            git
        ;;
    init-repositories)
        git submodule update --init sources/*
        ;;
    clean)
        ;;
esac


for file in $ZE_PACKAGES_ROOT_DIR/*.sh ; do
    if [[ -d $file ]]; then
        continue
    fi

    external_name=$(basename -s ".sh" $file)

    ze_info "Processing package '$external_name'..."

    ze_external_process "$external_name"
    if [[ $? -ne 0 ]]; then
        ze_info "Processing package '$external_name' has been failed."
    else
        ze_info "Package '$external_name' has been processed succesfully."
    fi
done


exit $ZE_SUCCESS