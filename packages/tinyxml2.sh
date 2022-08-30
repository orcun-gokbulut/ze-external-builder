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
}

function ze_package_compile() {
    ze_cmake_build
}

function ze_package_gather() 
{
    ze_cmake_install
    rm -rfv $ZE_PACKAGE_BUILD_DIR/ze_build_install/lib/cmake
    rm -rfv $ZE_PACKAGE_BUILD_DIR/ze_build_install/lib/pkgconfig
    cp -rv $ZE_PACKAGE_BUILD_DIR/ze_build_install/include $ZE_PACKAGE_OUTPUT_DIR
    cp -rv $ZE_PACKAGE_BUILD_DIR/ze_build_install/lib $ZE_PACKAGE_OUTPUT_DIR
}