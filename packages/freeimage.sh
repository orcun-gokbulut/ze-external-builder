#!/bin/bash

# Copyright (C) 2022 Y. Orçun GÖKBULUT <orcun.gokbulut@gmail.com>
# All rights reserved. 


ZE_PACKAGE_NAME="freeimage"
ZE_PACKAGE_DESCRIPTION="Freeimage image library"
ZE_PACKAGE_VERSION="3.18"
ZE_PACKAGE_TARGET="target"
ZE_PACKAGE_REPOSITORY="https://github.com/mlomb/FreeImage.git"
ZE_PACKAGE_BRANCH="3.18"


function ze_package_configure() 
{
    ze_cmake_configure
    return $?
}

function ze_package_compile() {
    ze_cmake_build
    return $?
}

function ze_package_gather() 
{
    ze_exec mkdir -p "$ZE_PACKAGE_OUTPUT_DIR/lib" || return $ZE_FAIL
    ze_exec cp -v "$ZE_PACKAGE_BUILD_DIR/libFreeImage$ZE_STATIC_LIBRARY_EXTENSION $ZE_PACKAGE_OUTPUT_DIR/lib" || return $ZE_FAIL

    ze_exec mkdir -p "$ZE_PACKAGE_OUTPUT_DIR/include" || return $ZE_FAIL
    ze_exec cp -v "$ZE_PACKAGE_SOURCE_DIR/Source/FreeImage.h" "$ZE_PACKAGE_OUTPUT_DIR/include" || return $ZE_FAIL

    return $ZE_SUCCESS
}