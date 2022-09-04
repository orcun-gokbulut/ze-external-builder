#!/bin/bash

# Copyright (C) 2022 Y. Orçun GÖKBULUT <orcun.gokbulut@gmail.com>
# All rights reserved. 


ZE_PACKAGE_NAME="re2c"
ZE_PACKAGE_DESCRIPTION="Lexer generator"
ZE_PACKAGE_VERSION="3.0"
ZE_PACKAGE_TARGET="host"
ZE_PACKAGE_TYPE="universal"
ZE_PACKAGE_REPOSITORY="https://github.com/skvadrik/re2c.git"
ZE_PACKAGE_BRANCH="3.0"


function ze_package_configure() 
{
    ze_cmake_configure
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
    ze_exec cp -rv $ZE_PACKAGE_BUILD_DIR/ze_build_install/include $ZE_PACKAGE_OUTPUT_DIR || return $ZE_FAIL
    ze_exec cp -rv $ZE_PACKAGE_BUILD_DIR/ze_build_install/lib $ZE_PACKAGE_OUTPUT_DIR || return $ZE_FAIL

    return $ZE_SUCCESS
}