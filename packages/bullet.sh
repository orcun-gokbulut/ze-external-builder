#!/bin/bash

# Copyright (C) 2022 Y. Orçun GÖKBULUT <orcun.gokbulut@gmail.com>
# All rights reserved. 


ZE_PACKAGE_NAME="bullet"
ZE_PACKAGE_DESCRIPTION="Bullet physics simulation library."
ZE_PACKAGE_VERSION="2.82"
ZE_PACKAGE_TARGET="target"
ZE_PACKAGE_REPOSITORY="https://github.com/bulletphysics/bullet3.git"
ZE_PACKAGE_BRANCH="2.82"


function ze_package_configure() 
{
    ze_cmake_configure \
        -D BUILD_CPU_DEMOS:BOOL=NO \
        -D BUILD_DEMOS:BOOL=NO \
        -D BUILD_EXTRAS:BOOL=NO \
        -D BUILD_UNIT_TESTS:BOOL=NO \
        -D BUILD_MULTITHREADING:BOOL=NO \
        -D USE_GLUT:BOOL=NO \
        -D USE_GRAPHICAL_BENCHMARK:BOOL=NO
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