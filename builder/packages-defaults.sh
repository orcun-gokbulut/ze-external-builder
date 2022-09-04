#!/bin/bash

# Copyright (C) 2022 Y. Orçun GÖKBULUT <orcun.gokbulut@gmail.com>
# All rights reserved. 

function ze_package_generate_registeration_start()
{
    echo "ze_external_register(" > "$ZE_PACKAGE_REGISTRATION_FILE"
    echo "    NAME $ZE_PACKAGE_NAME" >> "$ZE_PACKAGE_REGISTRATION_FILE"
    echo "    ARCHITECTURE $ZE_ARCHITECTURE" >> "$ZE_PACKAGE_REGISTRATION_FILE"
    echo "    OS $ZE_OPERATING_SYSTEM" >> "$ZE_PACKAGE_REGISTRATION_FILE"
    echo "    TOOLCHAIN $ZE_TOOLCHAIN" >> "$ZE_PACKAGE_REGISTRATION_FILE"


    # UNIVERSAL
    if [[ -d "$ZE_PACKAGE_OUTPUT_DIR/bin" ]]; then
        echo '    BIN "${CMAKE_CURRENT_SOURCE_DIR}/bin"' >> "$ZE_PACKAGE_REGISTRATION_FILE"
    fi

    if [[ -d "$ZE_PACKAGE_OUTPUT_DIR/lib" ]]; then
        echo '    LIB "${CMAKE_CURRENT_SOURCE_DIR}/lib"' >> "$ZE_PACKAGE_REGISTRATION_FILE"
    fi

    if [[ -d "$ZE_PACKAGE_OUTPUT_DIR/slib" ]]; then
        echo '    SLIB "${CMAKE_CURRENT_SOURCE_DIR}/slib"' >> "$ZE_PACKAGE_REGISTRATION_FILE"
    fi

    if [[ -d "$ZE_PACKAGE_OUTPUT_DIR/include" ]]; then
        echo '    INCLUDE "${CMAKE_CURRENT_SOURCE_DIR}/include"' >> "$ZE_PACKAGE_REGISTRATION_FILE"
    fi

    if [[ -d "#ZE_PACKAGE_OUTPUT_DIR/runtime" ]]; then
        echo '    RUNTIME "${CMAKE_CURRENT_SOURCE_DIR}/runtime"' >> "$ZE_PACKAGE_REGISTRATION_FILE"
    fi


    # DEBUG
    if [[ -d "$ZE_PACKAGE_OUTPUT_DIR/debug/bin" ]]; then
        echo '    BIN_DEBUG "${CMAKE_CURRENT_SOURCE_DIR}/debug/bin"' >> "$ZE_PACKAGE_REGISTRATION_FILE"
    fi

    if [[ -d "$ZE_PACKAGE_OUTPUT_DIR/debug/lib" ]]; then
        echo '    LIB_DEBUG "${CMAKE_CURRENT_SOURCE_DIR}/debug/lib"' >> "$ZE_PACKAGE_REGISTRATION_FILE"
    fi

    if [[ -d "$ZE_PACKAGE_OUTPUT_DIR/debug/slib" ]]; then
        echo '    SLIB_DEBUG "${CMAKE_CURRENT_SOURCE_DIR}/debug/slib"' >> "$ZE_PACKAGE_REGISTRATION_FILE"
    fi

    if [[ -d "$ZE_PACKAGE_OUTPUT_DIR/debug/include" ]]; then
        echo '    INCLUDE_DEBUG "${CMAKE_CURRENT_SOURCE_DIR}/debug/include"' >> "$ZE_PACKAGE_REGISTRATION_FILE"
    fi

    if [[ -d "$ZE_PACKAGE_OUTPUT_DIR/debug/runtime" ]]; then
        echo '    RUNTIME_DEBUG "${CMAKE_CURRENT_SOURCE_DIR}/debug/runtime"' >> "$ZE_PACKAGE_REGISTRATION_FILE"
    fi


    # RELEASE
    if [[ -d "$ZE_PACKAGE_OUTPUT_DIR/release/bin" ]]; then
        echo '    BIN_RELEASE "${CMAKE_CURRENT_SOURCE_DIR}/release/bin"' >> "$ZE_PACKAGE_REGISTRATION_FILE"
    fi

    if [[ -d "$ZE_PACKAGE_OUTPUT_DIR/release/lib" ]]; then
        echo '    LIB_RELEASE "${CMAKE_CURRENT_SOURCE_DIR}/release/lib"' >> "$ZE_PACKAGE_REGISTRATION_FILE"
    fi

    if [[ -d "$ZE_PACKAGE_OUTPUT_DIR/release/slib" ]]; then
        echo '    SLIB_RELEASE "${CMAKE_CURRENT_SOURCE_DIR}/release/slib"' >> "$ZE_PACKAGE_REGISTRATION_FILE"
    fi

    if [[ -d "$ZE_PACKAGE_OUTPUT_DIR/release/include" ]]; then
        echo '    INCLUDE_RELEASE "${CMAKE_CURRENT_SOURCE_DIR}/release/include"' >> "$ZE_PACKAGE_REGISTRATION_FILE"
    fi

    if [[ -d "$ZE_PACKAGE_OUTPUT_DIR/release/runtime" ]]; then
        echo '    RUNTIME_RELEASE "${CMAKE_CURRENT_SOURCE_DIR}/release/runtime"' >> "$ZE_PACKAGE_REGISTRATION_FILE"
    fi

}

function ze_package_generate_registeration_end()
{
    echo ")" >> "$ZE_PACKAGE_REGISTRATION_FILE"
}

function ze_package_build_default()
{
    ze_operation_exec_clone
    if [[ $? -ne 0 ]]; then
        return $ZE_FAIL
    fi

    ze_operation_exec_configure
    if [[ $? -ne 0 ]]; then
        return $ZE_FAIL
    fi

    ze_operation_exec_compile
    if [[ $? -ne 0 ]]; then
        return $ZE_FAIL
    fi

    ze_operation_exec_gather
    if [[ $? -ne 0 ]]; then
        return $ZE_FAIL
    fi

    return $ZE_SUCCESS
}

function ze_package_check_default()
{ 
    ze_platform_check
    if [[ $? -ne 0 ]]; then
        return $ZE_FAIL
    fi

    return $ZE_SUCCESS
}

function ze_package_bootstrap_default()
{ 
    return $ZE_SUCCESS
}

function ze_package_clean_default()
{ 
    return $ZE_SUCCESS
}

function ze_package_clone_default() 
{
    mkdir -p $ZE_PACKAGE_SOURCE_DIR
    cd $ZE_PACKAGE_SOURCE_DIR

    local is_inside_work_tree="$(git rev-parse --is-inside-work-tree)"
    local origin_url="$(git remote get-url origin)"

    if [[ "$is_inside_work_tree" == "false" || "$origin_url" != "$ZE_PACKAGE_REPOSITORY" ]]; then
        git clone --depth 1 --recurse-submodules --shallow-submodules --branch "$ZE_PACKAGE_BRANCH" "$ZE_PACKAGE_REPOSITORY" "$ZE_PACKAGE_SOURCE_DIR"
        if [[ $? -ne 0 ]]; then
            ze_error "Cannot clone repository."
            return $ZE_FAIL
        fi
    fi

    local branch="$(git symbolic-ref -q --short HEAD || git describe --tags --exact-match)"
    if [[ "$branch" != "$ZE_PACKAGE_BRANCH" ]]; then
        git checkout "$ZE_PACKAGE_BRANCH"
        if [[ $? -ne 0 ]]; then
            ze_error "Cannot update git submodules."
            return $ZE_FAIL
        fi

        git submodule update --recursive --init --depth=1
        if [[ $? -ne 0 ]]; then
            ze_error "Cannot update git submodules."
            return $ZE_FAIL
        fi
    fi
}

function ze_package_configure_default()
{ 
    return $ZE_SUCCESS
}

function ze_package_configure_default()
{ 
    return $ZE_SUCCESS
}

function ze_package_gather_default() 
{
    return $ZE_SUCCESS
}

function ze_package_generate_registration_default()
{
    ze_package_generate_registeration_start
    ze_package_generate_registeration_end
}