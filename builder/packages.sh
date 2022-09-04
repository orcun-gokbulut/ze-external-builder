#!/bin/bash

# Copyright (C) 2022 Y. Orçun GÖKBULUT <orcun.gokbulut@gmail.com>
# All rights reserved. 


ZE_PACKAGES_ROOT_PATH="$ZE_ROOT_DIR/packages"

function ze_package_reset()
{
    ZE_PACKAGE_NAME=""
    ZE_PACKAGE_DESCRIPTION=""
    ZE_PACKAGE_VERSION=""
    ZE_PACKAGE_TARGET=""
    ZE_PACKAGE_TYPE="library"
    ZE_PACKAGE_ENABLED=1
    ZE_PACKAGE_REPOSITORY=""
    ZE_PACKAGE_BRANCH=""
    ZE_PACKAGE_ARCHITECTURES=()
    ZE_PACKAGE_OPERATING_SYSTEMS=()
    ZE_PACKAGE_TOOLCHAINS=()
    ZE_PACKAGE_BUILD_TYPE=""
    ZE_PACKAGE_SOURCE_DIR=""
    ZE_PACKAGE_BUILD_DIR=""
    ZE_PACKAGE_OUTPUT_DIR=""
    ZE_PACKAGE_REGISTRATION_FILE=""
    ZE_PACKAGE_LOG_FILE=""
    ZE_PACKAGE_DEPENDENCIES=()

    eval "function ze_package_check() { ze_package_check_default ; return $? ; }"
    eval "function ze_package_bootstrap() { ze_package_bootstrap_default ; return $? ; }"
    eval "function ze_package_build() { ze_package_build_default ; return $? ; }"
    eval "function ze_package_clone() { ze_package_clone_default ; return $? ; }"
    eval "function ze_package_clean() { ze_package_clean_default ; return $? ; }"
    eval "function ze_package_configure() { ze_package_configure_default ; return $? ; }"
    eval "function ze_package_compile() { ze_package_compile_default ; return $? ; }"
    eval "function ze_package_gather() { ze_package_gather_default ; return $? ; }"
    eval "function ze_package_generate_registration() { ze_package_generate_registration_default ; return $? ; }"
    
    ZE_MODULE_NAME="Core"
}

function ze_package_load()
{
    local package_name="$1"

    ze_package_reset

    if [[ ! -f "$ZE_ROOT_DIR/packages/$package_name.sh" ]]; then
        ze_error "Cannot load package '$package_name'. Package script does not exists."
        return $ZE_FAIL
    fi

    source "$ZE_ROOT_DIR/packages/$package_name.sh"

    if [[ "$ZE_PACKAGE_NAME" == "" || "$ZE_PACKAGE_NAME" != "$package_name" ]]; then
        ze_error "Cannot load package '$package_name'. Package script did not respond correctly."
        ze_package_reset
        return $ZE_FAIL
    fi

    ZE_MODULE_NAME="$ZE_PACKAGE_NAME"
    ZE_PACKAGE_TIMESTAMP="$ZE_TIMESTAMP"
    ZE_PACKAGE_SOURCE_DIR="$ZE_SOURCE_DIR/$ZE_PACKAGE_NAME"
    ZE_PACKAGE_BUILD_DIR="$ZE_BUILD_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME"
    ZE_PACKAGE_OUTPUT_DIR="$ZE_OUTPUT_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME"
    ZE_PACKAGE_REGISTRATION_FILE="$ZE_PACKAGE_OUTPUT_DIR/CMakeLists.txt"
    ZE_PACKAGE_INFORMATION_FILE="$ZE_PACKAGE_OUTPUT_DIR/ze-external-package.txt"

    if [[ $ZE_SEPARATE_LOG_FILES -ne 0 ]]; then
        ZE_PACKAGE_LOG_FILE="$ZE_LOG_DIR/$ZE_PLATFORM-$ZE_PACKAGE_TIMESTAMP-$ZE_PACKAGE_NAME-$ZE_OPERATION.log"
    else
        ZE_PACKAGE_LOG_FILE="$ZE_LOG_FILE"
    fi

    return $ZE_SUCCESS
}

function ze_package_process_unit() 
{
    ze_operation_info

    if [[ $ZE_VERBOSE -ne 0 ]]; then
        ze_operation_route 2>&1 | tee -a "$ZE_PACKAGE_LOG_FILE"
        return $?
    else
        ze_operation_route 2>&1 >> "$ZE_PACKAGE_LOG_FILE"
        return $?
    fi
}

function ze_package_filter()
{
    if [[ "$ZE_FILTER_MODE" == "INCLUDE" ]]; then
        local found=0
        for current in "${ZE_INCLUDED[@]}" ; do
            if [ "$current" == "$1" ] ; then
                found=1
                break
            fi
        done

        if [[ $found -eq 0 ]]; then
            ze_detail "Skipping not included package '$1'."
            return $ZE_FAIL
        fi
    elif [[ "$ZE_FILTER_MODE" == "EXCLUDE" ]]; then
        for current in "${ZE_EXCLUDED[@]}" ; do
            if [[ "$current" == "$1" ]]; then
                ze_detail "Skipping excluded package  '$1'."
                return $ZE_FAIL
            fi
        done
    fi

    return $ZE_SUCCESS
}

function ze_package_process() 
{
    local result_sum=0

    for file in $ZE_PACKAGES_ROOT_DIR/*.sh ; do
        if [[ -d $file ]]; then
            continue
        fi

        local package_name=$(basename -s ".sh" $file)
        
        ze_package_filter $package_name
        if [[ $? -ne $ZE_SUCCESS ]]; then
            continue
        fi

        ze_package_load "$package_name"
        if [[ $? -ne 0 ]]; then
            if [[ $ZE_STOP_ON_ERROR -eq 0 ]]; then
                exit $ZE_FAIL
            fi

            ze_package_reset
            return $ZE_FAIL
        fi

        if [[ $ZE_PACKAGE_ENABLED -eq 0 ]]; then
            ze_detail "Skipping disabled package $ZE_PACKAGE_NAME."
            return $ZE_SUCCESS
        fi

        ze_operation_exec_check
        if [[ $? -ne 0 ]]; then
            ze_detail "Package check with current configuration has been failed. Skipping package."
            return $ZE_SUCCESS
        fi
        
        ze_info "Processing package '$ZE_PACKAGE_NAME'..."
        ze_package_process_unit
        if [[ $? -ne 0 ]]; then
            ze_info "Processing package '$package_name' has been failed."
            result_sum=1
        else
            ze_info "Package '$package_name' has been processed succesfully."
        fi
    done
    
    exit $result_sum
}