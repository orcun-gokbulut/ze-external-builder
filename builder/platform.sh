

function ze_platform_detect()
{
    # Operating Systems
    case "$OSTYPE" in
        linux*)
            ZE_OPERATING_SYSTEM="linux"
            ZE_TOOLCHAIN="gcc"
            ;;
        darwin*)
            ZE_OPERATING_SYSTEM="macosx"
            prefered_toolchain="clang"
            ;;
        bsd*)
            ZE_OPERATING_SYSTEM="bsd"
            prefered_toolchain="clang"
            ;;
        msys*)
            ZE_OPERATING_SYSTEM="windows"
            prefered_toolchain="gcc"
            ;;
        cygwin*)
            ZE_OPERATING_SYSTEM="windows"
            
            ;;
        *)
            ze_critical "Cannot detect operating system. '$OSTYPE' is unknown/unsupported operating system."
    esac

    if [[ "$ZE_OPERATING_SYSTEM" == "windows" ]]; then
        ZE_ARCHITECTURE="x64"
    else
        MACHINE_TYPE="$(uname -m)"
        case "$MACHINE_TYPE" in
            i*86)
                ZE_ARCHITECTURE="x86"
                ;;
            "x86_64")
                ZE_ARCHITECTURE="x64"
                ;;
            arm*)
                ZE_ARCHITECTURE="arm"
                ;;
            "aarch64")
                ZE_ARCHITECTURE="arm64"
                ;;
            *)
                ze_critical "Cannot detect architecture. '$MACHINE_TYPE' is unknown/unsupported architecture."
                ;;
        esac
    fi
}


function ze_platform_normalize_toolset()
{
    case "$ZE_TOOLCHAIN" in
        "gcc")
            ZE_COMPILER="gcc"
            ZE_COMPILER_VERSION="$(gcc -dumpversion)"
            ZE_TOOLCHAIN="$ZE_COMPILER$ZE_COMPILER_VERSION"
            ;;
        "gcc7")
            ZE_COMPILER="gcc"
            ZE_COMPILER_VERSION=7
            ;;
        "gcc8")
            ZE_COMPILER="gcc"
            ZE_COMPILER_VERSION=8
            ;;
        "gcc9")
            ZE_COMPILER="gcc"
            ZE_COMPILER_VERSION=9
            ;;
        "gcc10")
            ZE_COMPILER="gcc"
            ZE_COMPILER_VERSION=10
            ;;
        "clang")
            ZE_COMPILER="clang"
            ZE_COMPILER_VERSION="$(clang -dumpversion | sed -nr 's/^([0-9]+)\..*$/\1/p')"
            ZE_TOOLCHAIN="$ZE_COMPILER$ZE_COMPILER_VERSION"
            ;;
        "clang5")
            ZE_COMPILER="clang"
            ZE_COMPILER_VERSION="5"
            ;;
        "clang6")
            ZE_COMPILER="clang"
            ZE_COMPILER_VERSION="6"
            ;;
        "clang7")
            ZE_COMPILER="clang"
            ZE_COMPILER_VERSION="7"
            ;;
        "clang8")
            ZE_COMPILER="clang"
            ZE_COMPILER_VERSION="8"
            ;;
        "clang9")
            ZE_COMPILER="clang"
            ZE_COMPILER_VERSION="9"
            ;;
        "clang10")
            ZE_COMPILER="clang"
            ZE_COMPILER_VERSION="10"
            ;;
        "clang11")
            ZE_COMPILER="clang"
            ZE_COMPILER_VERSION="11"
            ;;
        "clang12")
            ZE_COMPILER="clang"
            ZE_COMPILER_VERSION="12"
            ;;
        "msvc")
            ZE_COMPILER="msvc"
            ZE_VERSION="143"
            ZE_TOOLCHAIN="$ZE_COMPILER$ZE_COMPILER_VERSION"
            ;;
        "msvc110")
            ZE_COMPILER="msvc"
            ZE_VERSION="110"
            ;;
        "msvc120")
            ZE_COMPILER="msvc"
            ZE_VERSION="120"
            ;;
        "msvc130")
            ZE_COMPILER="msvc"
            ZE_VERSION="130"
            ;;
        "msvc140")
            ZE_COMPILER="msvc"
            ZE_VERSION="140"
            ;;
        "msvc141")
            ZE_COMPILER="msvc"
            ZE_VERSION="141"
            ;;
        "msvc142")
            ZE_COMPILER="msvc"
            ZE_VERSION="142"
            ;;
        "msvc143")
            ZE_COMPILER="msvc"
            ZE_VERSION="143"
            ;;
    esac

    ZE_CXX_COMPILER=""
    ZE_C_COMPILER=""
    ZE_CMAKE_TOOLCHAIN=""
    if [[ "$ZE_COMPILER" == "msvc" ]]; then
        case "$ZE_COMPILER_VERSION" in
            110)
                ZE_CMAKE_TOOLCHAIN='--G "Visual Studio 11 2012"'
                ;;
            120)
                ZE_CMAKE_TOOLCHAIN='--G "Visual Studio 12 2013"'
                ;;
            120)
                ZE_CMAKE_TOOLCHAIN='--G "Visual Studio 14 2015"'
                ;;
            140)
                ZE_CMAKE_TOOLCHAIN='--G "Visual Studio 15 2017"'
                ;;
            141)
                ZE_CMAKE_TOOLCHAIN='--G "Visual Studio 16 2019"'
                ;;
            142)
                ZE_CMAKE_TOOLCHAIN='--G "Visual Studio 17 2022"'
                ;;
        esac

        case "$ZE_ARCHITECTURE" in
            "x86")
                ZE_CMAKE_TOOLCHAIN+=" -A Win32"
                ;;
            "x64") 
                ZE_CMAKE_TOOLCHAIN+=" -A x64"
                ;;
            "arm")
                ZE_CMAKE_TOOLCHAIN+=" -A ARM"
                ;;
            "arm64")
                ZE_CMAKE_TOOLCHAIN+=" -A ARM64"
                ;;
        esac
    elif [[ "$ZE_COMPILER" == "gcc" ]]; then
        local c_compiler_path=$(which gcc-$ZE_COMPILER_VERSION)
        ZE_C_COMPILER=$(readlink -f $c_compiler_path)

        local cpp_compiler_path=$(which g++-$ZE_COMPILER_VERSION)
        ZE_CXX_COMPILER=$(readlink -f $cpp_compiler_path)
    elif [[ "$ZE_COMPILER" == "clang" ]]; then
        local c_compiler_path=$(which clang-$ZE_COMPILER_VERSION)
        ZE_C_COMPILER=$(readlink -f $c_compiler_path)

        local cpp_compiler_path=$(which clang++-$ZE_COMPILER_VERSION)
        ZE_CXX_COMPILER=$(readlink -f $cpp_compiler_path)
    fi
}

function ze_platform_check()
{
    if [[ "${#ZE_PACKAGE_ARCHITECTURES[@]}" -ne 0 ]]; then
        local found=0
        for arch in "${ZE_PACKAGE_ARCHITECTURES[@]}" ; do
            if [[ "$arch" == "$ZE_ARCHITECTURE" ]]; then
                found=1;
                break;
            fi
        done

        if [[ $found -eq 0 ]]; then
            return 1
        fi
    fi

    if [[ "${#ZE_PACKAGE_OPERATING_SYSTEMS[@]}" -ne 0 ]]; then
        local found=0
        for os in "${ZE_PACKAGE_OPERATING_SYSTEMS[@]}" ; do
            if [[ "$os" == "$ZE_OPERATING_SYSTEM" ]]; then
                found=true;
                break;
            fi
        done

        if [[ $found -eq 0 ]]; then
            return 1
        fi
    fi

    return 0
}