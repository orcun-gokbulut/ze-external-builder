

function ze_operation_info()
{
    ZE_PACKAGE_ARCHITECTURES_TEXT=""
    for current in "${ZE_PACKAGE_ARCHITECTURES[@]}" ; do
        if [[ "$ZE_PACKAGE_ARCHITECTURES_TEXT" != "" ]]; then
            ZE_PACKAGE_ARCHITECTURES_TEXT+=", "
        fi
        ZE_PACKAGE_ARCHITECTURES_TEXT+="$current"
    done

    ZE_PACKAGE_OPERATING_SYSTEMS_TEXT=""
    for current in "${ZE_PACKAGE_OPERATING_SYSTEMS[@]}" ; do
        if [[ "$ZE_PACKAGE_OPERATING_SYSTEMS_TEXT" != "" ]]; then
            ZE_PACKAGE_OPERATING_SYSTEMS_TEXT+=", "
        fi
        ZE_PACKAGE_OPERATING_SYSTEMS_TEXT+="$current"
    done
    
    ZE_PACKAGE_TOOLCHAINS_TEXT=""
    for current in "${ZE_PACKAGE_TOOLCHAINS[@]}" ; do
        if [[ "$ZE_PACKAGE_TOOLCHAINS_TEXT" != "" ]]; then
            ZE_PACKAGE_TOOLCHAINS_TEXT+=", "
        fi
        ZE_PACKAGE_TOOLCHAINS_TEXT+="$current"
    done

    ze_detail "ZE_PACKAGE_NAME = $ZE_PACKAGE_NAME"
    ze_detail "ZE_PACKAGE_DESCRIPTION = $ZE_PACKAGE_DESCRIPTION"
    ze_detail "ZE_PACKAGE_VERSION = $ZE_PACKAGE_VERSION"
    ze_detail "ZE_PACKAGE_ENABLED = $ZE_PACKAGE_ENABLED"
    ze_detail "ZE_PACKAGE_TYPE = $ZE_PACKAGE_TYPE"
    ze_detail "ZE_PACKAGE_TARGET = $ZE_PACKAGE_TARGET"
    ze_detail "ZE_PACKAGE_REPOSITORY = $ZE_PACKAGE_REPOSITORY"
    ze_detail "ZE_PACKAGE_BRANCH = $ZE_PACKAGE_BRANCH"
    ze_detail "ZE_PACKAGE_OPERATING_SYSTEMS = $ZE_PACKAGE_OPERATING_SYSTEMS_TEXT"
    ze_detail "ZE_PACKAGE_ARCHITECTURES = $ZE_PACKAGE_ARCHITECTURES_TEXT"
    ze_detail "ZE_PACKAGE_TOOLCHAINS = $ZE_PACKAGE_TOOLCHAINS_TEXT"
    ze_detail "ZE_PACKAGE_BUILD_TARGET = $ZE_PACKAGE_BUILD_TARGET"
    ze_detail "ZE_PACKAGE_BUILD_TYPE = $ZE_PACKAGE_BUILD_TYPE"
    ze_detail "ZE_PACKAGE_SOURCE_DIR = $ZE_PACKAGE_SOURCE_DIR"
    ze_detail "ZE_PACKAGE_BUILD_DIR = $ZE_PACKAGE_BUILD_DIR"
    ze_detail "ZE_PACKAGE_OUTPUT_DIR = $ZE_PACKAGE_OUTPUT_DIR"
    ze_detail "ZE_PACKAGE_TIMESTAMP = $ZE_PACKAGE_TIMESTAMP"
    ze_detail "ZE_PACKAGE_LOG_FILE = $ZE_PACKAGE_LOG_FILE"

    return $ZE_SUCCESS
}

function ze_operation_exec_check()
{
    ze_package_check
    return $?
}

function ze_operation_exec_bootstrap()
{
    ze_info "Bootstraping $ZE_PACKAGE_NAME..."

    ze_package_bootstrap
    if [[ $? -ne 0 ]]; then
        ze_error "Bootstrapping of external package '$ZE_PACKAGE_NAME' has been FAILED."
        return $ZE_FAIL
    fi

    ze_info "Package '$ZE_PACKAGE_NAME' has been bootstrapped successfully."

    return $ZE_SUCCESS
}

function ze_operation_exec_clone()
{
    ze_info "Cloning package '$ZE_PACKAGE_NAME'."

    mkdir -p $ZE_PACKAGE_SOURCE_DIR

    ze_package_clone
    if [[ $? -ne 0 ]]; then
        ze_error "Cloning of package '$ZE_PACKAGE_NAME' has been FAILDED."
        return $ZE_FAIL
    fi

    ze_info "Package '$ZE_PACKAGE_NAME' has been cloned successfully."

    return $ZE_SUCCESS
}

function ze_operation_exec_build()
{
    ze_package_build
    return $?
}

function ze_operation_exec_clean()
{
    ze_info "Cleaning package $ZE_PACKAGE_NAME..."

    ze_package_clean
    if [[ $? -ne 0 ]]; then
        ze_error "Cleaning of package '$ZE_PACKAGE_NAME' has been FAILDED."
        return $ZE_FAIL
    fi

    rm -rfv "$ZE_PACKAGE_BUILD_DIR"
    rm -rfv "$ZE_PACKAGE_OUTPUT_DIR"

    ze_info "Package '$ZE_PACKAGE_NAME' has been cleaned succesfully."

    return $ZE_SUCCESS
}


function ze_operation_exec_configure()
{
    ze_info "Configuring package '$ZE_PACKAGE_NAME'..."

    mkdir -p "$ZE_PACKAGE_BUILD_DIR"
    cd "$ZE_PACKAGE_BUILD_DIR"

    ze_package_configure
    if [[ $? -ne 0 ]]; then
        ze_error "Configuring of package '$ZE_PACKAGE_NAME' has been FAILDED."
        return $ZE_FAIL
    fi

    ze_info "Package '$ZE_PACKAGE_NAME' has been configured succesfully."

    return $ZE_SUCCESS
}

function ze_operation_exec_compile()
{
    ze_info "Compiling package '$ZE_PACKAGE_NAME'..."

    mkdir -p "$ZE_PACKAGE_BUILD_DIR"
    cd "$ZE_PACKAGE_BUILD_DIR"

    ze_package_compile
    if [[ $? -ne 0 ]]; then
        ze_error "Building of package '$ZE_PACKAGE_NAME' has been FAILDED."
        return $ZE_FAIL
    fi
    
    ze_info "Package '$ZE_PACKAGE_NAME' has been compiled succesfully."

    return $ZE_SUCCESS
}


function ze_operation_exec_gather()
{
    ze_info "Gathering output of package '$ZE_PACKAGE_NAME'..."

    mkdir -p "$ZE_PACKAGE_OUTPUT_DIR"
    cd "$ZE_PACKAGE_OUTPUT_DIR"

    ze_package_gather
    if [[ $? -ne 0 ]]; then
        ze_error "Output gathering of package '$ZE_PACKAGE_NAME' has been FAILDED."
        return $ZE_FAIL
    fi

    ze_info "Output of package '$ZE_PACKAGE_NAME' has been gathered succesfully."

    return $ZE_SUCCESS
}


function ze_operation_exec_generate_package_info()
{
    ze_info "Generating package information of package '$ZE_PACKAGE_NAME'..."

    mkdir -p "$ZE_PACKAGE_OUTPUT_DIR"
    echo "Version: $ZE_PACKAGE_VERSION" > "$ZE_PACKAGE_INFORMATION_FILE"
    echo "Repository: $ZE_PACKAGE_REPOSITORY" >> "$ZE_PACKAGE_INFORMATION_FILE"
    echo "Branch: $ZE_PACKAGE_BRANCH" >> "$ZE_PACKAGE_INFORMATION_FILE"

    ze_info "Package information of package '$ZE_PACKAGE_NAME' has been generated succesfully."

    return $ZE_SUCCESS
}

function ze_operation_exec_generate_registration()
{
    ze_info "Generating registeration of package '$ZE_PACKAGE_NAME'..."

    mkdir -p "$ZE_PACKAGE_OUTPUT_DIR"
    ze_package_generate_registration

    ze_info "Registration of package '$ZE_PACKAGE_NAME' has been generated succesfully."

    return $ZE_SUCCESS
}

function ze_operation_exec_list()
{
    ze_output "$ZE_PACKAGE_NAME"
    return $ZE_SUCCESS
}

function ze_operation_register()
{
    ze_info "Generating adding package '$ZE_PACKAGE_NAME' to master registration..."

    echo "add_subdirectory($ZE_PACKAGE_NAME)" >> $ZE_MASTER_REGISTRATION_FILE
    
    ze_info "Package '$ZE_PACKAGE_NAME' has been succefully added to master registration master registrtraion."
}

function ze_operation_route_build_internal()
{
    local result=""
    case "$ZE_OPERATION" in
        build)
            ze_operation_exec_build
            result=$1
            ;;
        clean)
            ze_operation_exec_clean
            result=$?
            ;;
        configure)
            ze_operation_exec_configure
            result=$?
            ;;
        compile)
            ze_operation_exec_compile
            result=$?
            ;;
        gather)
            ze_operation_exec_gather
            result=$?
            ;;
        *)
            ze_critical "Unknown operation. Operation name: '$ZE_OPERATION'"
            return $ZE_FAIL
            ;;
    esac

    if [[ $result -ne 0 && $ZE_STOP_ON_ERROR -ne 0 ]]; then
        exit $ZE_FAIL
    fi
}

function ze_operation_route_build()
{
    package_result=0
    if [[ $ZE_PACKAGE_TYPE == "universal" ]]; then
        # UNIVERSAL BUILD
        ZE_PACKAGE_BUILD_TYPE=""
        ZE_PACKAGE_BUILD_DIR="$ZE_BUILD_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME"
        ZE_PACKAGE_OUTPUT_DIR="$ZE_OUTPUT_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME"
        
        ze_operation_route_build_internal
        package_result=$?
    else
        if [[ $ZE_BUILD_TYPE == "both" ]]; then
            # RELEASE BUILD
            ze_info "Processing release configuration..."
            ZE_PACKAGE_BUILD_TYPE="release"
            ZE_PACKAGE_BUILD_DIR="$ZE_BUILD_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME/$ZE_PACKAGE_BUILD_TYPE"
            ZE_PACKAGE_OUTPUT_DIR="$ZE_OUTPUT_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME/$ZE_PACKAGE_BUILD_TYPE"

            ze_operation_route_build_internal
            package_result=$?

            if [[ $package_result -ne 0 ]]; then
                ze_info "Processing package '$ZE_PACKAGE_NAME' in release configuration has been failed."
                package_result=1
            else
                ze_info "Package '$ZE_PACKAGE_NAME' in release configuration has been processed succesfully."
            fi


            if [[ $package_result -eq 0 || $ZE_STOP_ON_ERROR -ne 0 ]]; then
                #DEBUG BUILD
                ze_info "Processing package '$ZE_PACKAGE_NAME' in debug configuration..."
                ZE_PACKAGE_BUILD_TYPE="debug"           
                ZE_PACKAGE_BUILD_DIR="$ZE_BUILD_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME/$ZE_PACKAGE_BUILD_TYPE"
                ZE_PACKAGE_OUTPUT_DIR="$ZE_OUTPUT_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME/$ZE_PACKAGE_BUILD_TYPE"

                ze_operation_route_build_internal
                package_result=$?

                if [[ $package_result -ne 0 ]]; then
                    ze_info "Processing package '$ZE_PACKAGE_NAME' in debug configuration has been failed."
                    package_result=1
                else
                    ze_info "Package '$ZE_PACKAGE_NAME' in debug configuration has been processed succesfully."
                fi

                ZE_PACKAGE_BUILD_TYPE=""
                ZE_PACKAGE_BUILD_DIR="$ZE_BUILD_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME"
                ZE_PACKAGE_OUTPUT_DIR="$ZE_OUTPUT_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME"
            fi
        else
            # SELECTIVE BUILD
            ZE_PACKAGE_BUILD_TYPE="$ZE_BUILD_TYPE"
            ZE_PACKAGE_BUILD_DIR="$ZE_BUILD_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME/$ZE_PACKAGE_BUILD_TYPE"
            ZE_PACKAGE_OUTPUT_DIR="$ZE_OUTPUT_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME/$ZE_PACKAGE_BUILD_TYPE"

            ze_operation_route_build_internal
            package_result=$?
            
            ZE_PACKAGE_BUILD_TYPE=""
            ZE_PACKAGE_BUILD_DIR="$ZE_BUILD_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME"
            ZE_PACKAGE_OUTPUT_DIR="$ZE_OUTPUT_DIR/$ZE_PLATFORM/$ZE_PACKAGE_NAME"
        fi

        return $package_result
    fi
}

function ze_operation_route()
{
    local result=""
    case "$ZE_OPERATION" in
        bootstrap)
            ze_operation_exec_bootstrap
            result=$?
            ;;
        clone)
            ze_operation_exec_clone
            result=$?
            ;;
        generate-info)
            ze_operation_exec_generate_package_info
            result=$?
            ;;
        generate-registration)
            ze_operation_exec_generate_registration
            result=$?
            ;;
        list)
            ze_operation_exec_list
            result=$?
            ;;
        info)
            local verbose_old=$ZE_VERBOSE
            ZE_VERBOSE=1
            ze_operation_info
            result=$?            
            ZE_VERBOSE=$verbose_old
            ;;
        none)
            ze_info "Traversing external $ZE_PACKAGE_NAME."
            result=0
            ;;
        build)
            ze_operation_route_build || return $ZE_FAIL
            ze_operation_exec_generate_package_info || return $ZE_FAIL
            ze_operation_exec_generate_registration || return $ZE_FAIL
            ;;
        register)
            ze_operation_register
            ;;
        *)
            ze_operation_route_build
            result=$?
            ;;

    esac

    if [[ $result -ne 0 && $ZE_STOP_ON_ERROR -eq 0 ]]; then
        exit $ZE_FAIL
    fi
}
