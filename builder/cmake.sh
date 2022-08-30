#!/bin/bash

# Copyright (C) 2022 Y. Orçun GÖKBULUT <orcun.gokbulut@gmail.com>
# All rights reserved. 


function ze_cmake_configure() 
{
    ze_exec cmake \
        -Wno-dev \
        -S "$ZE_PACKAGE_SOURCE_DIR" \
        -B "$ZE_PACKAGE_BUILD_DIR" \
        -D CMAKE_BUILD_TYPE:BOOL="$ZE_BUILD_TYPE" \
        -D CMAKE_INSTALL_PREFIX:PATH="$ZE_PACKAGE_BUILD_DIR/ze_build_install" \
        $@ 
}

function ze_cmake_build()
{
    ze_exec MAKEFLAGS=-j$(nproc) cmake --build $ZE_PACKAGE_BUILD_DIR
}

function ze_cmake_install()
{
    ze_exec cmake --install $ZE_PACKAGE_BUILD_DIR
}