#!/bin/bash

# Copyright (C) 2022 Y. Orçun GÖKBULUT <orcun.gokbulut@gmail.com>
# All rights reserved. 

function ze_operation_info()
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

function ze_operation_exec_check()
{
    ZE_PACKAGE_LAST_OPERATION="Check $ZE_PACKAGE_BUILD_TYPE"

    ze_package_check
    return $?
}

function ze_operation_exec_bootstrap()
{
    ZE_PACKAGE_LAST_OPERATION="Bootstrap $ZE_PACKAGE_BUILD_TYPE"

    ze_info "Bootstraping $ZE_PACKAGE_NAME..."

    ze_package_bootstrap
    if [[ $? -ne 0 ]]; then
        ze_error "Bootstrapping of external package '$ZE_PACKAGE_NAME' has been FAILED."
        return $ZE_FAIL
    fi

    ze_info "Package '$ZE_PACKAGE_NAME' has been bootstrapped successfully."

    return $ZE_SUCCESS
}

function ze_operation_exec_clone()
{
    ZE_PACKAGE_LAST_OPERATION="Clone $ZE_PACKAGE_BUILD_TYPE"

    ze_info "Cloning package '$ZE_PACKAGE_NAME'."

    mkdir -p "$ZE_PACKAGE_SOURCE_DIR"

    ze_package_clone
    if [[ $? -ne 0 ]]; then
        ze_error "Cloning of package '$ZE_PACKAGE_NAME' has been FAILDED."
        return $ZE_FAIL
    fi

    ze_info "Package '$ZE_PACKAGE_NAME' has been cloned successfully."

    return $ZE_SUCCESS
}

function ze_operation_exec_build()
{
    ze_package_build
    return $?
}

function ze_operation_exec_clean()
{
    ZE_PACKAGE_LAST_OPERATION="Clean $ZE_PACKAGE_BUILD_TYPE"

    ze_info "Cleaning package $ZE_PACKAGE_NAME..."

    ze_package_clean
    if [[ $? -ne 0 ]]; then
        ze_error "Cleaning of package '$ZE_PACKAGE_NAME' has been FAILDED."
        return $ZE_FAIL
    fi

    rm -rfv "$ZE_PACKAGE_BUILD_DIR"
    rm -rfv "$ZE_PACKAGE_OUTPUT_DIR"

    ze_info "Package '$ZE_PACKAGE_NAME' has been cleaned succesfully."

    return $ZE_SUCCESS
}

function ze_operation_exec_configure()
{
    ZE_PACKAGE_LAST_OPERATION="Configure $ZE_PACKAGE_BUILD_TYPE"

    ze_info "Configuring package '$ZE_PACKAGE_NAME'..."

    mkdir -p "$ZE_PACKAGE_BUILD_DIR"
    cd "$ZE_PACKAGE_BUILD_DIR"

    ze_package_configure
    if [[ $? -ne 0 ]]; then
        ze_error "Configuring of package '$ZE_PACKAGE_NAME' has been FAILDED."
        return $ZE_FAIL
    fi

    ze_info "Package '$ZE_PACKAGE_NAME' has been configured succesfully."

    return $ZE_SUCCESS
}

function ze_operation_exec_compile()
{
    ZE_PACKAGE_LAST_OPERATION="Compile $ZE_PACKAGE_BUILD_TYPE"

    ze_info "Compiling package '$ZE_PACKAGE_NAME'..."

    mkdir -p "$ZE_PACKAGE_BUILD_DIR"
    cd "$ZE_PACKAGE_BUILD_DIR"

    ze_package_compile
    if [[ $? -ne 0 ]]; then
        ze_error "Building of package '$ZE_PACKAGE_NAME' has been FAILDED."
        return $ZE_FAIL
    fi
    
    ze_info "Package '$ZE_PACKAGE_NAME' has been compiled succesfully."

    return $ZE_SUCCESS
}


function ze_operation_exec_gather()
{
    ZE_PACKAGE_LAST_OPERATION="Gather $ZE_PACKAGE_BUILD_TYPE"

    ze_info "Gathering output of package '$ZE_PACKAGE_NAME'..."

    mkdir -p "$ZE_PACKAGE_OUTPUT_DIR"
    cd "$ZE_PACKAGE_OUTPUT_DIR"

    ze_package_gather
    if [[ $? -ne 0 ]]; then
        ze_error "Output gathering of package '$ZE_PACKAGE_NAME' has been FAILDED."
        return $ZE_FAIL
    fi

    ze_info "Output of package '$ZE_PACKAGE_NAME' has been gathered succesfully."

    return $ZE_SUCCESS
}


function ze_operation_exec_generate_package_info()
{
    ZE_PACKAGE_LAST_OPERATION="Generate Info $ZE_PACKAGE_BUILD_TYPE"

    ze_info "Generating package information of package '$ZE_PACKAGE_NAME'..."

    mkdir -p "$ZE_PACKAGE_OUTPUT_DIR"
    echo "Version: $ZE_PACKAGE_VERSION" > "$ZE_PACKAGE_INFORMATION_FILE"
    echo "Repository: $ZE_PACKAGE_REPOSITORY" >> "$ZE_PACKAGE_INFORMATION_FILE"
    echo "Branch: $ZE_PACKAGE_BRANCH" >> "$ZE_PACKAGE_INFORMATION_FILE"

    ze_info "Package information of package '$ZE_PACKAGE_NAME' has been generated succesfully."

    return $ZE_SUCCESS
}

function ze_operation_exec_generate_registration()
{
    ZE_PACKAGE_LAST_OPERATION="Generate Registration $ZE_PACKAGE_BUILD_TYPE"

    ze_info "Generating registeration of package '$ZE_PACKAGE_NAME'..."

    mkdir -p "$ZE_PACKAGE_OUTPUT_DIR"
    ze_package_generate_registration

    ze_info "Registration of package '$ZE_PACKAGE_NAME' has been generated succesfully."

    return $ZE_SUCCESS
}

function ze_operation_exec_list()
{
    ZE_PACKAGE_LAST_OPERATION="List $ZE_PACKAGE_BUILD_TYPE"

    ze_output "$ZE_PACKAGE_NAME"
    return $ZE_SUCCESS
}

function ze_operation_register()
{
    ZE_PACKAGE_LAST_OPERATION="Register"

    ze_info "Generating adding package '$ZE_PACKAGE_NAME' to master registration..."

    echo "add_subdirectory($ZE_PACKAGE_NAME)" >> $ZE_MASTER_REGISTRATION_FILE
    
    ze_info "Package '$ZE_PACKAGE_NAME' has been succefully added to master registration master registrtraion."
    
    return $ZE_SUCCESS
}

function ze_operation_route_build_internal()
{
    local operation_result=0
    case "$ZE_OPERATION" in
        build)
            ze_operation_exec_build
            operation_result=$?
            ;;
        clean)
            ze_operation_exec_clean
            operation_result=$?
            ;;
        configure)
            ze_operation_exec_configure
            operation_result=$?
            ;;
        compile)
            ze_operation_exec_compile
            operation_result=$?
            ;;
        gather)
            ze_operation_exec_gather
            operation_result=$?
            ;;
        *)
            ze_critical "Unknown operation. Operation name: '$ZE_OPERATION'"
            return $ZE_FAIL
            ;;
    esac

    if [[ $operation_result -ne 0 && $ZE_STOP_ON_ERROR -ne 0 ]]; then
        return $ZE_FAIL
    fi
}

function ze_operation_route_build()
{   
    local build_result=0
    local package_result=0
    
    if [[ $ZE_PACKAGE_TYPE == "universal" ]]; then
        # UNIVERSAL BUILD
        ZE_PACKAGE_BUILD_TYPE=""
        ZE_PACKAGE_BUILD_DIR="$ZE_BUILD_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME"
        ZE_PACKAGE_OUTPUT_DIR="$ZE_OUTPUT_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME"
        
        ze_operation_route_build_internal
        package_result=$?
        if [[ $package_result -ne 0 ]]; then
            ze_info "Processing package '$ZE_PACKAGE_NAME' has been failed."

            if [[ $ZE_STOP_ON_ERROR -ne 0 ]]; then
                return $ZE_FAIL
            fi
        else
            ze_info "Package '$ZE_PACKAGE_NAME' has been processed succesfully."
        fi
    else
        if [[ $ZE_BUILD_TYPE == "both" ]]; then
            # RELEASE BUILD
            ze_info "Processing release configuration..."
            ZE_PACKAGE_BUILD_TYPE="release"
            ZE_PACKAGE_BUILD_DIR="$ZE_BUILD_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME/$ZE_PACKAGE_BUILD_TYPE"
            ZE_PACKAGE_OUTPUT_DIR="$ZE_OUTPUT_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME/$ZE_PACKAGE_BUILD_TYPE"

            ze_operation_route_build_internal
            build_result=$?

            if [[ $build_result -ne 0 ]]; then
                ze_info "Processing package '$ZE_PACKAGE_NAME' in release configuration has been failed."

                package_result=1
                if [[ $ZE_STOP_ON_ERROR -ne 0 ]]; then
                    return $ZE_FAIL
                fi
            else
                ze_info "Package '$ZE_PACKAGE_NAME' in release configuration has been processed succesfully."
            fi

            #DEBUG BUILD
            ze_info "Processing package '$ZE_PACKAGE_NAME' in debug configuration..."
            ZE_PACKAGE_BUILD_TYPE="debug"           
            ZE_PACKAGE_BUILD_DIR="$ZE_BUILD_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME/$ZE_PACKAGE_BUILD_TYPE"
            ZE_PACKAGE_OUTPUT_DIR="$ZE_OUTPUT_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME/$ZE_PACKAGE_BUILD_TYPE"

            ze_operation_route_build_internal
            build_result=$?

            if [[ $build_result -ne 0 ]]; then
                ze_info "Processing package '$ZE_PACKAGE_NAME' in debug configuration has been failed."
                
                package_result=1
                if [[ $ZE_STOP_ON_ERROR -ne 0 ]]; then
                    return $ZE_FAIL
                fi
            else
                ze_info "Package '$ZE_PACKAGE_NAME' in debug configuration has been processed succesfully."
            fi

            ZE_PACKAGE_BUILD_TYPE=""
            ZE_PACKAGE_BUILD_DIR="$ZE_BUILD_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME"
            ZE_PACKAGE_OUTPUT_DIR="$ZE_OUTPUT_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME"
        else
            # SELECTIVE BUILD
            ZE_PACKAGE_BUILD_TYPE="$ZE_BUILD_TYPE"
            ZE_PACKAGE_BUILD_DIR="$ZE_BUILD_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME/$ZE_PACKAGE_BUILD_TYPE"
            ZE_PACKAGE_OUTPUT_DIR="$ZE_OUTPUT_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME/$ZE_PACKAGE_BUILD_TYPE"

            ze_operation_route_build_internal
            build_result=$?

            if [[ $build_result -ne 0 ]]; then
                ze_info "Processing package '$ZE_PACKAGE_NAME' in $ZE_PACKAGE_BUILD_TYPE configuration has been failed."
                
                package_result=1
                if [[ $ZE_STOP_ON_ERROR -ne 0 ]]; then
                    return $ZE_FAIL
                fi
            else
                ze_info "Package '$ZE_PACKAGE_NAME' in $ZE_PACKAGE_BUILD_TYPE configuration has been processed succesfully."
            fi

            ZE_PACKAGE_BUILD_TYPE=""
            ZE_PACKAGE_BUILD_DIR="$ZE_BUILD_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME"
            ZE_PACKAGE_OUTPUT_DIR="$ZE_OUTPUT_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME"
        fi

        return $package_result
    fi
}

function ze_operation_route()
{
    local operation_result=0
    case "$ZE_OPERATION" in
        bootstrap)
            ze_operation_exec_bootstrap
            operation_result=$?
            ;;
        clone)
            ze_operation_exec_clone
            operation_result=$?
            ;;
        generate-info)
            ze_operation_exec_generate_package_info
            operation_result=$?
            ;;
        generate-registration)
            ze_operation_exec_generate_registration
            operation_result=$?
            ;;
        list)
            ze_operation_exec_list
            operation_result=$?
            ;;
        info)
            local verbose_old=$ZE_VERBOSE
            ZE_VERBOSE=1
            ze_operation_info
            operation_result=$?            
            ZE_VERBOSE=$verbose_old
            ;;
        none)
            ze_info "Traversing external $ZE_PACKAGE_NAME."
            operation_result=0
            ;;
        build)
            ze_operation_route_build && \
            ze_operation_exec_generate_package_info && \
            ze_operation_exec_generate_registration
            operation_result=$?
            ;;
        register)
            ze_operation_register
            operation_result=$?
            ;;
        *)
            ze_operation_route_build
            operation_result=$?
            ;;

    esac

    return $operation_result
}
