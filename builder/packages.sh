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
    ZE_PACKAGE_LAST_OPERATION=""

    eval "function ze_package_check() { ze_package_check_default || return $ZE_FAIL ; }"
    eval "function ze_package_bootstrap() { ze_package_bootstrap_default|| return $ZE_FAIL ; }"
    eval "function ze_package_build() { ze_package_build_default || return $ZE_FAIL ; }"
    eval "function ze_package_clone() { ze_package_clone_default || return $ZE_FAIL ; }"
    eval "function ze_package_clean() { ze_package_clean_default || return $ZE_FAIL ; }"
    eval "function ze_package_configure() { ze_package_configure_default || return $ZE_FAIL ; }"
    eval "function ze_package_compile() { ze_package_compile_default || return $ZE_FAIL ; }"
    eval "function ze_package_gather() { ze_package_gather_default || return $ZE_FAIL ; }"
    eval "function ze_package_generate_registration() { ze_package_generate_registration_default || return $ZE_FAIL ; }"
    
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
        return ${PIPESTATUS[0]}
    else
        ze_operation_route >> "$ZE_PACKAGE_LOG_FILE" 2>&1 
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
    local general_result=0
    local package_result=0

    for file in "$ZE_PACKAGES_ROOT_DIR"/*.sh ; do
        if [[ -d $file ]]; then
            continue
        fi

        local package_name="$(basename -s ".sh" $file)"
        
        ze_package_filter "$package_name"
        if [[ $? -ne $ZE_SUCCESS ]]; then
            continue
        fi

        ze_package_load "$package_name"
        package_result=$?
        if [[ $package_result -ne 0 ]]; then
            ZE_PROCESSED_PACKAGES+=("$package_name")
            ZE_PROCESSED_PACKAGE_RESULTS+=("Failure (Load)")

            if [[ $ZE_STOP_ON_ERROR -ne 0 ]]; then
                return $ZE_FAIL
            fi

            continue
        fi

        if [[ $ZE_PACKAGE_ENABLED -eq 0 ]]; then
            ze_detail "Skipping disabled package $ZE_PACKAGE_NAME."
            continue
        fi

        ze_info "Processing package '$ZE_PACKAGE_NAME'..."
        ZE_PROCESSED_PACKAGES+=("$package_name")

        ze_operation_exec_check
        package_result=$?
        if [[ $package_result -eq $ZE_SKIP ]]; then
            ze_detail "Package check with current configuration has been failed. Skipping package."
            continue
        elif [[ $package_result -ne 0 ]]; then
            ze_error "Package check with current configuration has been failed."                  
            ZE_PROCESSED_PACKAGE_RESULTS+=("Failure (Check)")
            general_result=1

            if [[ $ZE_STOP_ON_ERROR -ne 0 ]]; then
                ze_package_reset
                return $ZE_FAIL
            fi
        fi
        
        ze_package_process_unit
        package_result=$?
        if [[ $package_result -ne 0 ]]; then
            ze_error "Processing package '$ZE_PACKAGE_NAME' has been failed."
            ZE_PROCESSED_PACKAGE_RESULTS+=("Failure ($ZE_PACKAGE_LAST_OPERATION)")
            general_result=1

            if [[ $ZE_STOP_ON_ERROR -ne 0 ]]; then
                ze_package_reset
                return $ZE_FAIL
            fi
        fi        

        ze_info "Package '$ZE_PACKAGE_NAME' has been processed succesfully."
        ZE_PROCESSED_PACKAGE_RESULTS+=("Success")
    done

    ze_package_reset
    
    return $general_result
}