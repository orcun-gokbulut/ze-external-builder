#!/bin/bash

# Copyright (C) 2022 Y. Orçun GÖKBULUT <orcun.gokbulut@gmail.com>
# All rights reserved. 


ZE_PACKAGE_NAME="vorbis"
ZE_PACKAGE_DESCRIPTION="Ogg Vorbis audio encoding/decoding library"
ZE_PACKAGE_VERSION="1.3.7"
ZE_PACKAGE_TARGET="target"
ZE_PACKAGE_REPOSITORY="https://github.com/xiph/vorbis.git"
ZE_PACKAGE_BRANCH="v1.3.7"


function ze_package_configure() 
{
    ze_cmake_configure \
        -D INSTALL_CMAKE_PACKAGE_MODULE:BOOL=NO \
        -D BUILD_SHARED_LIBS:BOOL=NO \
        -D OGG_INCLUDE_DIR=$ZE_OUTPUT_DIR/$ZE_PLATFORM/ogg/$ZE_PACKAGE_BUILD_TYPE/include \
        -D OGG_LIBRARY=$ZE_OUTPUT_DIR/$ZE_PLATFORM/ogg/$ZE_PACKAGE_BUILD_TYPE/lib
    
    return $?
}

function ze_package_compile() {
    ze_cmake_build

    return $?
}

function ze_package_gather() 
{
    ze_cmake_install || return $ZE_FAIL
    rm -rfv $ZE_PACKAGE_BUILD_DIR/ze_build_install/lib/pkgconfig || return $ZE_FAIL
    ze_exec cp -rv $ZE_PACKAGE_BUILD_DIR/ze_build_install/include $ZE_PACKAGE_OUTPUT_DIR || return $ZE_FAIL
    ze_exec cp -rv $ZE_PACKAGE_BUILD_DIR/ze_build_install/lib $ZE_PACKAGE_OUTPUT_DIR || return $ZE_FAIL

    return $ZE_SUCCESS
}