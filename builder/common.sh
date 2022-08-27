#!/bin/bash

function ze_exec() {
    local command="$@"
    ze_detail "Executing command: $command"
    eval $@
}
