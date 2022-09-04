#!/bin/bash

# Copyright (C) 2022 Y. Orçun GÖKBULUT <orcun.gokbulut@gmail.com>
# All rights reserved. 


ZE_PACKAGE_NAME="lemon"
ZE_PACKAGE_DESCRIPTION="LALR parser generator"
ZE_PACKAGE_VERSION="?"
ZE_PACKAGE_TARGET="host"
ZE_PACKAGE_TYPE="universal"
ZE_PACKAGE_REPOSITORY="https://github.com/compiler-dept/lemon.git"
ZE_PACKAGE_BRANCH="master"


function ze_package_compile()
{
    ze_exec gcc -std=gnu11 -Os -Wall -o "$ZE_PACKAGE_BUILD_DIR/lemon" "$ZE_PACKAGE_SOURCE_DIR/lemon.c"
    return $?
}

function ze_package_gather()
{
    ze_exec mkdir -p "$ZE_PACKAGE_OUTPUT_DIR/bin" || return $ZE_FAIL
    ze_exec cp -v "$ZE_PACKAGE_BUILD_DIR/lemon" "$ZE_PACKAGE_OUTPUT_DIR/bin/lemon" || return $ZE_FAIL
    
    return $ZE_SUCCESS
}