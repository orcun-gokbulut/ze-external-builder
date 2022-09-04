#!/bin/bash

# Copyright (C) 2022 Y. Orçun GÖKBULUT <orcun.gokbulut@gmail.com>
# All rights reserved. 


ZE_PACKAGE_NAME="clang"
ZE_PACKAGE_DESCRIPTION="Clang compiler"
ZE_PACKAGE_VERSION="3.6.2"
ZE_PACKAGE_TARGET="host"
ZE_PACKAGE_REPOSITORY="https://github.com/llvm/llvm-project.git"
ZE_PACKAGE_BRANCH="llvmorg-3.6.2"


function ze_package_configure() 
{    
    ze_cmake_configure \
        -S $ZE_PACKAGE_SOURCE_DIR/llvm \
        -DLLVM_EXTERNAL_CLANG_BUILD:BOOL=ON \
        -DLLVM_EXTERNAL_CLANG_SOURCE_DIR:PATH=$ZE_PACKAGE_SOURCE_DIR/clang \
        -DBUILD_CLANG_FORMAT_VS_PLUGIN:BOOL=OFF \
        -DBUILD_SHARED_LIBS:BOOL=OFF \
        -DCLANG_BUILD_EXAMPLES:BOOL=OFF \
        -DCLANG_ENABLE_ARCMT:BOOL=OFF \
        -DCLANG_ENABLE_STATIC_ANALYZER:BOOL=OFF \
        -DCLANG_INCLUDE_DOCS:BOOL=OFF \
        -DCLANG_INCLUDE_TESTS:BOOL=OFF \
        -DCLANG_PLUGIN_SUPPORT:BOOL=OFF \
        -DLIBCLANG_BUILD_STATIC:BOOL=ON \
        -DLLVM_BUILD_32_BITS:BOOL=OFF \
        -DLLVM_BUILD_DOCS:BOOL=OFF \
        -DLLVM_BUILD_EXAMPLES:BOOL=OFF \
        -DLLVM_BUILD_EXTERNAL_COMPILER_RT:BOOL=OFF \
        -DLLVM_BUILD_RUNTIME:BOOL=OFF \
        -DLLVM_BUILD_TESTS:BOOL=OFF \
        -DLLVM_BUILD_TOOLS:BOOL=ON \
        -DLLVM_INCLUDE_DOCS:BOOL=OFF \
        -DLLVM_INCLUDE_EXAMPLES:BOOL=OFF \
        -DLLVM_INCLUDE_TESTS:BOOL=OFF \
        -DLLVM_INCLUDE_TOOLS:BOOL=ON \
        -DLLVM_INCLUDE_UTILS:BOOL=OFF \
        -DLLVM_INSTALL_TOOLCHAIN_ONLY:BOOL=OFF

    return $?
}

function ze_package_compile() {
    ze_cmake_build
    return $?
}

function ze_package_gather() 
{
    ze_cmake_install
    ze_exec cp -rv $ZE_PACKAGE_BUILD_DIR/ze_build_install/include $ZE_PACKAGE_OUTPUT_DIR || return $ZE_FAIL
    ze_exec cp -rv $ZE_PACKAGE_BUILD_DIR/ze_build_install/lib $ZE_PACKAGE_OUTPUT_DIR || return $ZE_FAIL
    ze_exec rm -rv $ZE_PACKAGE_OUTPUT_DIR/lib/clang || return $ZE_FAIL

    return $ZE_SUCCESS
}