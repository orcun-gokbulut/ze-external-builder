#!/bin/bash

# Copyright (C) 2022 Y. Orçun GÖKBULUT <orcun.gokbulut@gmail.com>
# All rights reserved. 


ZE_PACKAGE_NAME="zlib"
ZE_PACKAGE_DESCRIPTION="A compression utility library"
ZE_PACKAGE_VERSION="1.2.5.3"
ZE_PACKAGE_TARGET="target"
ZE_PACKAGE_REPOSITORY="https://github.com/madler/zlib.git"
ZE_PACKAGE_BRANCH="v1.2.5.3"


function ze_package_configure() 
{
    ze_exec rm -vf "$ZE_PACKAGE_SOURCE_DIR/zconf.h"
    ze_cmake_configure \
        -D BUILD_SHARED_LIBS:BOOL=NO
}

function ze_package_compile() {
    ze_cmake_build
}

function ze_package_gather() 
{
    ze_cmake_install
    cp -rv $ZE_PACKAGE_BUILD_DIR/ze_build_install/include $ZE_PACKAGE_OUTPUT_DIR
    cp -rv $ZE_PACKAGE_BUILD_DIR/ze_build_install/lib $ZE_PACKAGE_OUTPUT_DIR
}