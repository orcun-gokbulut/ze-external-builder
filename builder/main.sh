#!/bin/bash

# Copyright (C) 2022 Y. Orçun GÖKBULUT <orcun.gokbulut@gmail.com>
# All rights reserved. 

function ze_main()
{
    ZE_BUILDER_ROOT_DIR_TEMP="$(dirname "$BASH_SOURCE")"
    ZE_BUILDER_ROOT_DIR="$(realpath -m "$ZE_BUILDER_ROOT_DIR_TEMP")"
    ZE_PACKAGES_ROOT_DIR="$ZE_ROOT_DIR/packages"

    ZE_MODULE_NAME="Core"

    source "$ZE_BUILDER_ROOT_DIR/log.sh"
    source "$ZE_BUILDER_ROOT_DIR/common.sh"
    source "$ZE_BUILDER_ROOT_DIR/platform.sh"
    source "$ZE_BUILDER_ROOT_DIR/cmake.sh"
    source "$ZE_BUILDER_ROOT_DIR/arguments.sh"
    source "$ZE_BUILDER_ROOT_DIR/packages.sh"
    source "$ZE_BUILDER_ROOT_DIR/packages-defaults.sh"
    source "$ZE_BUILDER_ROOT_DIR/operations.sh"
  
    ze_platform_detect
    ze_arguments_parse $@
    ze_platform_normalize_toolset
    
    # Normalize Paths
    ZE_BUILD_DIR=$(realpath -m "$ZE_BUILD_DIR")
    ZE_OUTPUT_DIR=$(realpath -m "$ZE_OUTPUT_DIR")
    ZE_LOG_DIR=$(realpath -m "$ZE_LOG_DIR")
    ZE_MASTER_REGISTRATION_FILE="$ZE_OUTPUT_DIR/$ZE_PLATFORM/CMakeLists.txt"

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
    ze_detail "ZE_PLATFORM = $ZE_PLATFORM"
    ze_detail "ZE_OPERATIONG_SYSTEM = $ZE_OPERATING_SYSTEM"
    ze_detail "ZE_ARCHITECTURE = $ZE_ARCHITECTURE"
    ze_detail "ZE_TOOLCHAIN = $ZE_TOOLCHAIN"
    ze_detail "ZE_COMPILER = $ZE_COMPILER"
    ze_detail "ZE_COMPILER_VERSION = $ZE_COMPILER_VERSION"
    ze_detail "ZE_C_COMPILER = $ZE_C_COMPILER"
    ze_detail "ZE_CXX_COMPILER = $ZE_CXX_COMPILER"
    ze_detail "ZE_CMAKE_TOOLCHAIN = $ZE_CMAKE_TOOLCHAIN"
    ze_detail "ZE_BUILD_TYPE = $ZE_BUILD_TYPE"
    ze_detail "ZE_SOURCE_DIR = $ZE_SOURCE_DIR"
    ze_detail "ZE_BUILD_DIR = $ZE_BUILD_DIR"
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
    ze_detail "ZE_STOP_ON_ERROR = $ZE_STOP_ON_ERROR"
    ze_detail "ZE_OPERATION = $ZE_OPERATION"


    case "$ZE_OPERATION" in
        build)
            truncate --size 0 $ZE_MASTER_REGISTRATION_FILE
            ;;

        register)
            truncate --size 0 $ZE_MASTER_REGISTRATION_FILE
            ;;

        full-clean)
            ze_info "Clearing everthing..."
            rm -rfv "$ZE_BUILD_DIR"
            rm -rfv "$ZE_LOG_DIR"
            rm -rfv "$ZE_SOURCE_DIR"
            rm -rfv "$ZE_OUTPUT_DIR"
            exit $ZE_SUCCESS
            ;;
    esac

    local process_result=0
    ze_package_reset
    ze_package_process
    process_result=$?
 
    ze_output " Package                      Result"
    ze_output "-------------------------------------------"
    for i in "${!ZE_PROCESSED_PACKAGES[@]}" ; do
        local packageName="${ZE_PROCESSED_PACKAGES[$i]}"
        local packageResult="${ZE_PROCESSED_PACKAGE_RESULTS[$i]}"
        printf -v output_row ' % -2d %-25s %-15s' $((i + 1)) "$packageName" "$packageResult"
        ze_output "$output_row"
    done

    exit $process_result
}