#!/bin/bash

# Copyright (C) 2022 Y. Orçun GÖKBULUT <orcun.gokbulut@gmail.com>
# All rights reserved. 


ZE_PACKAGE_NAME="tinyxml2"
ZE_PACKAGE_DESCRIPTION="XML parser library"
ZE_PACKAGE_VERSION="9.0.0"
ZE_PACKAGE_TARGET="target"
ZE_PACKAGE_REPOSITORY="https://github.com/leethomason/tinyxml2.git"
ZE_PACKAGE_BRANCH="9.0.0"


function ze_package_configure() 
{
    ze_cmake_configure \
        -D BUILD_TESTING:BOOL=NO \
        -D tinyxml2_BUILD_TESTING:BOOL=NO

    return $?
}

function ze_package_compile() {
    ze_cmake_build
    return $?
}

function ze_package_gather() 
{
    ze_cmake_install || return $ZE_FAIL
    rm -rfv "$ZE_PACKAGE_BUILD_DIR/ze_build_install/lib/cmake" || return $ZE_FAIL
    rm -rfv "$ZE_PACKAGE_BUILD_DIR/ze_build_install/lib/pkgconfig" || return $ZE_FAIL
    cp -rv "$ZE_PACKAGE_BUILD_DIR/ze_build_install/include" "$ZE_PACKAGE_OUTPUT_DIR" || return $ZE_FAIL
    cp -rv "$ZE_PACKAGE_BUILD_DIR/ze_build_install/lib" "$ZE_PACKAGE_OUTPUT_DIR" || return $ZE_FAIL

    return $ZE_SUCCESS
}