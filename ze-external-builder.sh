#!/bin/bash

# Copyright (C) 2022 Y. Orçun GÖKBULUT <orcun.gokbulut@gmail.com>
# All rights reserved. 

ZE_SCRIPT_PATH_TEMP="$BASH_SOURCE"
ZE_SCRIPT_PATH=$(realpath "$ZE_SCRIPT_PATH_TEMP")
ZE_ROOT_DIR_TEMP=$(dirname "$ZE_SCRIPT_PATH")
ZE_ROOT_DIR=$(realpath -m "$ZE_ROOT_DIR_TEMP")
ZE_SCRIPT_FILENAME=$(basename "$BASH_SOURCE")
ZE_DEBUG=1
ZE_VERSION="0.1"

source "builder/main.sh" $@
