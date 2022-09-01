#!/bin/bash

# Copyright (C) 2022 Y. Orçun GÖKBULUT <orcun.gokbulut@gmail.com>
# All rights reserved. 


ZE_PACKAGES_ROOT_PATH="$ZE_ROOT_DIR/pacakges"

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

    eval "function ze_package_check() { ze_package_check_default ; return $? ; }"
    eval "function ze_package_bootstrap() { ze_package_bootstrap_default ; return $? ; }"
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
        ze_error "Cannot load package '$pacakge_name'. Package script did not respond correctly."
        ze_package_reset
        return $ZE_FAIL
    fi

    ZE_MODULE_NAME="$ZE_PACKAGE_NAME"
    ZE_PACKAGE_TIMESTAMP="$ZE_TIMESTAMP"
    ZE_PACKAGE_SOURCE_DIR="$ZE_SOURCE_DIR/$ZE_PACKAGE_NAME"
    ZE_PACKAGE_BUILD_DIR="$ZE_BUILD_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME/$ZE_PACKAGE_BUILD_TYPE"
    ZE_PACKAGE_REGISTRATION_FILE="$ZE_OUTPUT_DIR/$ZE_PLATFORM/CMakeLists.txt"

    if [[ ZE_PACKAGE_TYPE == "universal " ]]; then
        ZE_PACKAGE_OUTPUT_DIR="$ZE_OUTPUT_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME"
    else
        ZE_PACKAGE_OUTPUT_DIR="$ZE_OUTPUT_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME/$ZE_PACKAGE_BUILD_TYPE"
    fi

    if [[ $ZE_SEPARATE_LOG_FILES -ne 0 ]]; then
        ZE_PACKAGE_LOG_FILE="$ZE_LOG_DIR/$ZE_PLATFORM-$ZE_PACKAGE_TIMESTAMP-$ZE_PACKAGE_NAME-$ZE_OPERATION.log"
    else
        ZE_PACKAGE_LOG_FILE="$ZE_LOG_FILE"
    fi

    return $ZE_SUCCESS
}

function ze_external_operation_info()
{
    ZE_PACKAGE_ARCHITECTURES_TEXT=""
    for current in "${ZE_PACKAGE_ARCHITECTURES[@]}" ; do
        if [[ "$ZE_PACKAGE_ARCHITECTURES_TEXT" != "" ]]; then
            ZE_PACKAGE_ARCHITECTURES_TEXT+=", "
        fi
        ZE_PACKAGE_ARCHITECTURES_TEXT+="$current"
    done

    ZE_PACKAGE_OPERATING_SYSTEMS_TEXT=""
    for current in "${ZE_PACKAGE_OPERATING_SYSTEMS[@]}" ; do
        if [[ "$ZE_PACKAGE_OPERATING_SYSTEMS_TEXT" != "" ]]; then
            ZE_PACKAGE_OPERATING_SYSTEMS_TEXT+=", "
        fi
        ZE_PACKAGE_OPERATING_SYSTEMS_TEXT+="$current"
    done
    
    ZE_PACKAGE_TOOLCHAINS_TEXT=""
    for current in "${ZE_PACKAGE_TOOLCHAINS[@]}" ; do
        if [[ "$ZE_PACKAGE_TOOLCHAINS_TEXT" != "" ]]; then
            ZE_PACKAGE_TOOLCHAINS_TEXT+=", "
        fi
        ZE_PACKAGE_TOOLCHAINS_TEXT+="$current"
    done

    ze_detail "ZE_PACKAGE_NAME = $ZE_PACKAGE_NAME"
    ze_detail "ZE_PACKAGE_DESCRIPTION = $ZE_PACKAGE_DESCRIPTION"
    ze_detail "ZE_PACKAGE_VERSION = $ZE_PACKAGE_VERSION"
    ze_detail "ZE_PACKAGE_ENABLED = $ZE_PACKAGE_ENABLED"
    ze_detail "ZE_PACKAGE_TYPE = $ZE_PACKAGE_TYPE"
    ze_detail "ZE_PACKAGE_TARGET = $ZE_PACKAGE_TARGET"
    ze_detail "ZE_PACKAGE_REPOSITORY = $ZE_PACKAGE_REPOSITORY"
    ze_detail "ZE_PACKAGE_BRANCH = $ZE_PACKAGE_BRANCH"
    ze_detail "ZE_PACKAGE_OPERATING_SYSTEMS = $ZE_PACKAGE_OPERATING_SYSTEMS_TEXT"
    ze_detail "ZE_PACKAGE_ARCHITECTURES = $ZE_PACKAGE_ARCHITECTURES_TEXT"
    ze_detail "ZE_PACKAGE_TOOLCHAINS = $ZE_PACKAGE_TOOLCHAINS_TEXT"
    ze_detail "ZE_PACKAGE_BUILD_TARGET = $ZE_PACKAGE_BUILD_TARGET"
    ze_detail "ZE_PACKAGE_BUILD_TYPE = $ZE_PACKAGE_BUILD_TYPE"
    ze_detail "ZE_PACKAGE_SOURCE_DIR = $ZE_PACKAGE_SOURCE_DIR"
    ze_detail "ZE_PACKAGE_BUILD_DIR = $ZE_PACKAGE_BUILD_DIR"
    ze_detail "ZE_PACKAGE_OUTPUT_DIR = $ZE_PACKAGE_OUTPUT_DIR"
    ze_detail "ZE_PACKAGE_TIMESTAMP = $ZE_PACKAGE_TIMESTAMP"
    ze_detail "ZE_PACKAGE_LOG_FILE = $ZE_PACKAGE_LOG_FILE"

    return $ZE_SUCCESS
}

function ze_external_operation_bootstrap()
{
    ze_info "Bootstraping $ZE_PACKAGE_NAME..."

    ze_package_bootstrap
    if [[ $? -ne 0 ]]; then
        ze_error "Bootstrapping of external pacakge '$ZE_PACKAGE_NAME' has been FAILED."
        return $ZE_FAIL
    fi

    ze_info "Pacakge '$ZE_PACKAGE_NAME' has been bootstrapped successfully."

    return $ZE_SUCCESS
}

function ze_external_operation_clone()
{
    ze_info "Cloning package '$ZE_PACKAGE_NAME'."

    mkdir -p $ZE_PACKAGE_SOURCE_DIR

    ze_package_clone
    if [[ $? -ne 0 ]]; then
        ze_error "Cloning of pacakge '$ZE_PACKAGE_NAME' has been FAILDED."
        return $ZE_FAIL
    fi

    ze_info "Pacakge '$ZE_PACKAGE_NAME' has been cloned successfully."

    return $ZE_SUCCESS
}

function ze_external_operation_clean()
{
    ze_info "Cleaning pacakge $ZE_PACKAGE_NAME..."

    ze_package_clean
    if [[ $? -ne 0 ]]; then
        ze_error "Cloning of pacakge '$ZE_PACKAGE_NAME' has been FAILDED."
        return $ZE_FAIL
    fi

    rm -rfv "$ZE_PACKAGE_BUILD_DIR"
    rm -rfv "$ZE_PACKAGE_OUTPUT_DIR"

    ze_info "Package '$ZE_PACKAGE_NAME' has been cleaned succesfully."

    return $ZE_SUCCESS
}


function ze_external_operation_configure()
{
    ze_info "Configuring pacakge '$ZE_PACKAGE_NAME'..."

    mkdir -p "$ZE_PACKAGE_BUILD_DIR"
    cd "$ZE_PACKAGE_BUILD_DIR"

    ze_package_configure
    if [[ $? -ne 0 ]]; then
        ze_error "Configuring of pacakge '$ZE_PACKAGE_NAME' has been FAILDED."
        return $ZE_FAIL
    fi

    ze_info "Package '$ZE_PACKAGE_NAME' has been configured succesfully."

    return $ZE_SUCCESS
}

function ze_external_operation_compile()
{
    ze_info "Compiling package '$ZE_PACKAGE_NAME'..."

    mkdir -p "$ZE_PACKAGE_BUILD_DIR"
    cd "$ZE_PACKAGE_BUILD_DIR"

    ze_package_compile
    if [[ $? -ne 0 ]]; then
        ze_error "Building of pacakge '$ZE_PACKAGE_NAME' has been FAILDED."
        return $ZE_FAIL
    fi
    
    ze_info "Package '$ZE_PACKAGE_NAME' has been compiled succesfully."

    return $ZE_SUCCESS
}


function ze_external_operation_gather()
{
    ze_info "Gathering output of package '$ZE_PACKAGE_NAME'..."

    mkdir -p "$ZE_PACKAGE_OUTPUT_DIR"
    cd "$ZE_PACKAGE_OUTPUT_DIR"

    ze_package_gather
    if [[ $? -ne 0 ]]; then
        ze_error "Output gathering of pacakge '$ZE_PACKAGE_NAME' has been FAILDED."
        return $ZE_FAIL
    fi

    ze_info "Output of package '$ZE_PACKAGE_NAME' has been gathered succesfully."

    return $ZE_SUCCESS
}


function ze_external_operation_generate_package_info()
{
    ze_info "Generating package information of package '$ZE_PACKAGE_NAME'..."

    mkdir -p "$ZE_PACKAGE_OUTPUT_DIR"
    echo "Version: $ZE_PACKAGE_VERSION" > "$ZE_PACKAGE_OUTPUT_DIR/ze_package_version.txt"
    echo "Repository: $ZE_PACKAGE_REPOSITORY" >> "$ZE_PACKAGE_OUTPUT_DIR/ze_package_version.txt"
    echo "Branch: $ZE_PACKAGE_BRANCH" >> "$ZE_PACKAGE_OUTPUT_DIR/ze_package_version.txt"

    ze_info "Package information of package '$ZE_PACKAGE_NAME' has been generated succesfully."

    return $ZE_SUCCESS
}

function ze_external_operation_generate_registration()
{
    ze_info "Generating registeration of package '$ZE_PACKAGE_NAME'..."

    mkdir -p "$ZE_PACKAGE_OUTPUT_DIR"
    ze_package_generate_registration

    ze_info "Registration of package '$ZE_PACKAGE_NAME' has been generated succesfully."

    return $ZE_SUCCESS
}


function ze_external_operation_build() 
{
    ze_info "Building pacakge '$ZE_PACKAGE_NAME'..."

    ze_external_operation_clone
    if [[ $? -ne 0 ]]; then
        ze_error "Building of pacakge '$ZE_PACKAGE_NAME' has been FAILDED."
        return $ZE_FAIL
    fi

    ze_external_operation_configure
    if [[ $? -ne 0 ]]; then
        ze_error "Building of pacakge '$ZE_PACKAGE_NAME' has been FAILDED."
        return $ZE_FAIL
    fi

    ze_external_operation_compile
    if [[ $? -ne 0 ]]; then
        ze_error "Building of pacakge '$ZE_PACKAGE_NAME' has been FAILDED."
        return $ZE_FAIL
    fi

    ze_external_operation_gather
    if [[ $? -ne 0 ]]; then
        ze_error "Building of pacakge '$ZE_PACKAGE_NAME' has been FAILDED."
        return $ZE_FAIL
    fi

    ze_external_operation_generate_package_info

    ze_info "Package '$ZE_PACKAGE_NAME' has been build succesfully."

    return $ZE_SUCCESS
}


function ze_external_operation_list()
{
    ze_output "$ZE_PACKAGE_NAME"
    return $ZE_SUCCESS
}


function ze_external_process_route()
{
    local result=""
    case "$ZE_OPERATION" in
        bootstrap)
            ze_external_operation_bootstrap
            result=$?
            ;;
        clone)
            ze_external_operation_clone
            result=$?
            ;;
        generate-info)
            ze_external_operation_generate_package_info
            result=$?
            ;;
        generate-registration)
            ze_external_operation_generate_registration
            result=$?
            ;;
        list)
            ze_external_operation_list
            result=$?
            ;;
        info)
            local verbose_old=$ZE_VERBOSE
            ZE_VERBOSE=1
            ze_external_operation_info
            result=$?            
            ZE_VERBOSE=$verbose_old
            ;;
        none)
            ze_info "Traversing external $ZE_PACKAGE_NAME."
            result=0
            ;;
        *)
            return $ZE_SUCCESS
            ;;
    esac

    if [[ $result -ne 0 && $ZE_STOP_ON_ERROR -eq 0 ]]; then
        exit $ZE_FAIL
    fi
}

function ze_external_process_route()
{
    local result=""
    case "$ZE_OPERATION" in
        clean)
            ze_external_operation_clean
            result=$?
            ;;
        configure)
            ze_external_operation_configure
            result=$?
            ;;
        compile)
            ze_external_operation_compile
            result=$?
            ;;
        gather)
            ze_external_operation_gather
            result=$?
            ;;
        *)
            return $ZE_SUCCESS
            ;;
    esac

    if [[ $result -ne 0 && $ZE_STOP_ON_ERROR -eq 0 ]]; then
        exit $ZE_FAIL
    fi
}

function ze_external_process_package() 
{
    ze_external_operation_info

    local result=0
    if [[ $ZE_VERBOSE -ne 0 ]]; then
        ze_external_process_route 2>&1 | tee -a "$ZE_PACKAGE_LOG_FILE"
        result=$?

    else
        ze_external_process_route 2>&1 >> "$ZE_PACKAGE_LOG_FILE"
        result=$?
    fi

    return $result
}

function ze_external_process_pacakges() {
    local result_sum=0
    for file in $ZE_PACKAGES_ROOT_DIR/*.sh ; do
        if [[ -d $file ]]; then
            continue
        fi

        local package_name=$(basename -s ".sh" $file)

        ze_package_load "$package_name"
        if [[ $? -ne 0 ]]; then
            if [[ $ZE_STOP_ON_ERROR -eq 0 ]]; then
                exit $ZE_FAIL
            fi

            ze_package_reset
            return $ZE_FAIL
        fi

        if [[ $ZE_PACKAGE_ENABLED -eq 0 ]]; then
            ze_detail "Skipping disabled pacakge $ZE_PACKAGE_NAME."
            return $ZE_SUCCESS
        fi

        ze_platform_check
        if [[ $? -ne 0 ]]; then
            ze_detail "Skipping platform incompatible pacakge $ZE_PACKAGE_NAME."
            return $ZE_SUCCESS
        fi

        ze_package_check
        if [[ $? -ne 0 ]]; then
            ze_detail "Package check with current configuration has been failed. Skipping package."
            return $ZE_SUCCESS
        fi
        
        local package_result=0
        ze_info "Processing package '$ZE_PACKAGE_NAME'..."

        ze_external_process_route_generic

        if [[ $ZE_PACKAGE_TYPE == "universal" ]]; then
            # UNIVERSAL BUILD
            ZE_PACKAGE_BUILD_TYPE=""
            ze_external_process_route
        else
            if [[ $ZE_BUILD_TYPE == "both" ]]; then
                # RELEASE BUILD
                ZE_PACKAGE_BUILD_TYPE="release"
                ze_info "Processing release configuration..."
                ze_external_process_route
                if [[ $? -ne 0 ]]; then
                    ze_info "Processing package '$ZE_PACKAGE_NAME' in "$ configuration has been failed."
                    package_result=1
                else
                    ze_info "Package '$ZE_PACKAGE_NAME' in debug configuration has been processed succesfully."
                fi

                #DEBUG BUILD
                ze_info "Processing package '$ZE_PACKAGE_NAME' in debug configuration..."
                ZE_PACKAGE_BUILD_TYPE="debug"
                ze_external_process_route
                if [[ $? -ne 0 ]]; then
                    ze_info "Processing package '$ZE_PACKAGE_NAME' in debug configuration has been failed."
                    package_result=1
                else
                    ze_info "Package '$ZE_PACKAGE_NAME' in debug configuration has been processed succesfully."
                fi
            else
                # SELECTIVE BUILD
                ZE_PACKAGE_BUILD_TYPE="$ZE_BUILD_TYPE"
                ze_external_process_route
            fi
        fi

        if [[ $package_result -ne 0 ]]; then
            ze_info "Processing package '$package_name' has been failed."
            result_sum=1
        else
            ze_info "Package '$package_name' has been processed succesfully."
        fi
    done
    
    exit $result_sum
}