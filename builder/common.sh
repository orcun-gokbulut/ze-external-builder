#!/bin/bash


# Copyright (C) 2022 Y. Orçun GÖKBULUT <orcun.gokbulut@gmail.com>
# All rights reserved. 

function ze_exec() {
    local command="$@"
    ze_detail "Executing command: $command"
    eval $@
    return $?
}