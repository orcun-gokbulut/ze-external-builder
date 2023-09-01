#!/bin/bash

# Copyright (C) 2022 Y. Orçun GÖKBULUT <orcun.gokbulut@gmail.com>
# All rights reserved. 

declare -r ZE_SUCCESS=0
declare -r ZE_FAIL=1
declare -r ZE_SKIP=2


declare -r ZE_LOG_LEVEL_DEBUG=0
declare -r ZE_LOG_LEVEL_DETAIL=1
declare -r ZE_LOG_LEVEL_INFO=2
declare -r ZE_LOG_LEVEL_IMPORTANT=3
declare -r ZE_LOG_LEVEL_WARNING=4
declare -r ZE_LOG_LEVEL_ERROR=5
declare -r ZE_LOG_LEVEL_CRITICAL_ERROR=6

function ze_log_initialize()
{
    ZE_TIMESTAMP="$(date '+%Y%m%d%H%M%S')"
    if [[ "$ZE_LOG_FILE" == "" ]]; then
        mkdir -p "$ZE_LOG_DIR"
        ZE_LOG_FILE="$ZE_LOG_DIR/$ZE_PLATFORM-$ZE_TIMESTAMP-$ZE_OPERATION.log"
    fi
    ZE_LOG_FILE="$(realpath -m "$ZE_LOG_FILE")"

    if [[ "$ZE_LOG_FILE" != "" ]]; then
        if  [[ -f "$ZE_LOG_FILE" ]]; then
            echo "" >> "$ZE_LOG_FILE"
            echo "" >> "$ZE_LOG_FILE"
        fi
        echo "Start of the log - " $(date '+%d-%m-%Y %H:%M:%S') >> "$ZE_LOG_FILE"
    fi
}

function ze_output()
{
    if [[ $ZE_QUIET -ne 0 ]]; then
        return
    fi

    echo "$1"
}

function ze_output_v()
{

    if [[ $ZE_QUIET -ne 0 || $ZE_VERBOSE -eq 0 ]]; then
        return
    fi
    
    echo "$1"
}

function ze_output_q()
{
    echo "$1"
}

function ze_message()
{
    local module="$1"
    shift 1
    local level=$1
    shift 1
    local message="$*"

    local color_reset="\033[0m"
    local color_white_bold="\033[1;37m"
    local color_red="\033[0;31m"
    local color_red_bold="\033[1;31m"
    local color_red_background="\033[41m$color_white_bold"
    local color_yellow="\033[0;33m"

    case $level in
        $ZE_LOG_LEVEL_DEBUG)
            level_text="Debug"
            level_color="$color_reset"
            ;;
        $ZE_LOG_LEVEL_DETAIL)
            level_text="Info"
            level_color="$color_reset"
            ;;
        $ZE_LOG_LEVEL_INFO)
            level_text="Info"
            level_color="$color_reset"
            ;;
        $ZE_LOG_LEVEL_IMPORTANT)
            level_text="Info"
            level_color="$color_reset"
            ;;
        $ZE_LOG_LEVEL_WARNING)
            level_text="Warning"
            level_color="$color_yellow"
            ;;
        $ZE_LOG_LEVEL_ERROR)
            level_text="Error"
            level_color="$color_red"
            ;;
        $ZE_LOG_LEVEL_CRITICAL_ERROR)
            level_text="CRITICAL ERROR"
            level_color="$color_red_background"
            ;;
        *)
            level_text="UNKOWN"
            level_color="$color_red"
            ;;
    esac


    if [[ $ZE_LOG_ENABLED -ne 0 ]]; then
        echo "[$module] $level_text: $message" >> $ZE_LOG_FILE
    fi

    echo -e "$color_white_bold[$module]$color_reset $level_color$level_text$color_reset: $message"
}

function ze_debug()
{
    if [[ $ZE_DEBUG -eq 0 ]]; then
        return;
    fi

    ze_message "$ZE_MODULE_NAME" $ZE_LOG_LEVEL_DEBUG $1
}

function ze_detail()
{

    if [[ $ZE_QUIET -ne 0 || $ZE_VERBOSE -eq 0 ]]; then
        return
    fi

    ze_message "$ZE_MODULE_NAME" $ZE_LOG_LEVEL_DETAIL $1
}

function ze_info()
{
    if [[ $ZE_QUIET -ne 0 ]]; then
        return
    fi

    ze_message "$ZE_MODULE_NAME" $ZE_LOG_LEVEL_INFO $1
}

function ze_important()
{
    ze_message "$ZE_MODULE_NAME" $ZE_LOG_LEVEL_IMPORTANT $1
}

function ze_warning()
{
    ze_message "$ZE_MODULE_NAME" $ZE_LOG_LEVEL_WARNING $1
}

function ze_error()
{
    ze_message "$ZE_MODULE_NAME" $ZE_LOG_LEVEL_ERROR $1
}

function ze_critical()
{
    ze_message "$ZE_MODULE_NAME" $ZE_LOG_LEVEL_CRITICAL_ERROR $1
    set -e
    exit $ZE_FAIL
}