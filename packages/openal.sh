#!/bin/bash

# Copyright (C) 2022 Y. Orçun GÖKBULUT <orcun.gokbulut@gmail.com>
# All rights reserved. 


ZE_PACKAGE_NAME="openal"
ZE_PACKAGE_DESCRIPTION="Software implementation of OpenAL audio library."
ZE_PACKAGE_VERSION="1.17.2"
ZE_PACKAGE_TARGET="target"
ZE_PACKAGE_REPOSITORY="https://github.com/kcat/openal-soft.git"
ZE_PACKAGE_BRANCH="openal-soft-1.17.1"


function ze_package_configure() 
{
    ze_cmake_configure \
        -D ALSOFT_EXAMPLES:BOOL=NO \
        -D ALSOFT_UTILS:BOOL=NO \
        -D ALSOFT_TESTS:BOOL=NO \
        -D BUILD_TESTING:BOOL=NO
    return $?
}

function ze_package_compile()
{
    ze_cmake_build
    return $?
}

function ze_package_gather() 
{
    ze_cmake_install || return $ZE_FAIL
    ze_exec cp -rv "$ZE_PACKAGE_BUILD_DIR/ze_build_install/include" "$ZE_PACKAGE_OUTPUT_DIR" || return $ZE_FAIL
    ze_exec cp -rv "$ZE_PACKAGE_BUILD_DIR/ze_build_install/lib" "$ZE_PACKAGE_OUTPUT_DIR" || return $ZE_FAIL

    return $ZE_SUCCESS
}