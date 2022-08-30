#!/bin/bash

# Copyright (C) 2022 Y. Orçun GÖKBULUT <orcun.gokbulut@gmail.com>
# All rights reserved. 


ZE_PACKAGE_NAME="freetype"
ZE_PACKAGE_DESCRIPTION="Truetype font library"
ZE_PACKAGE_VERSION="2.5.5"
ZE_PACKAGE_TARGET="target"
ZE_PACKAGE_REPOSITORY="https://github.com/freetype/freetype.git"
ZE_PACKAGE_BRANCH="VER-2-5-5"


function ze_package_configure() 
{
    ze_cmake_configure
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