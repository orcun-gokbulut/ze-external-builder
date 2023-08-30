#!/bin/bash

# Copyright (C) 2022 Y. Orçun GÖKBULUT <orcun.gokbulut@gmail.com>
# All rights reserved. 


function ze_cmake_configure() 
{
    local compiler_override=""
    if [[ "$ZE_C_COMPILER" != "" ]]; then
        compiler_override="CC=$ZE_C_COMPILER CXX=$ZE_CXX_COMPILER"
    fi

    ze_exec $compiler_override cmake \
        -Wno-dev \
        -S "$ZE_PACKAGE_SOURCE_DIR" \
        -B "$ZE_PACKAGE_BUILD_DIR" \
        -D CMAKE_BUILD_TYPE:STRING="$ZE_PACKAGE_BUILD_TYPE" \
        -D CMAKE_INSTALL_PREFIX:PATH="$ZE_PACKAGE_BUILD_DIR/ze_build_install" \
        $ZE_CMAKE_TOOLCHAIN \
        $@ 
    return $?
}

function ze_cmake_build()
{
    ze_exec MAKEFLAGS=-j$(nproc) cmake --build $ZE_PACKAGE_BUILD_DIR --config $ZE_PACKAGE_BUILD_TYPE
    return $?
}

function ze_cmake_install()
{
    ze_exec cmake --install $ZE_PACKAGE_BUILD_DIR --config $ZE_PACKAGE_BUILD_TYPE
    return $?
}