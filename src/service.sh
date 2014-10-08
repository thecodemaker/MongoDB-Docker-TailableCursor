#!/usr/bin/env bash

# Check out README.md for more details

# Config file. Any settings "key=value" written there will override the
# global_variables defaults. Useful to avoid editing .sh
global_config=".config"

# This function will load all the variables defined here. They might be overridden
# by the 'global_config' file contents
global_variables() {
    global_software_name=""
    global_software_version=""

    mongos_host=""
    mongod_host=""
    mongo_port=""
    mongo_database=""

    output_file="../results/$$.output.csv"
    insert_test_data_js="js/insert_test_data.js"
    validate_data_js="js/validate_data.js"
}

global_variables_check() {
    [[ "$global_software_name" == "" ]] &&
    echo "Please check your configuration. '' is not a valid value for the setting 'global_software_name'" &&
    exit
    [[ "$global_software_version" == "" ]] &&
    echo "Please check your configuration. '' is not a valid value for the setting 'global_software_version'" &&
    exit
    [[ "$mongos_host" == "" ]] &&
    echo "Please check your configuration. '' is not a valid value for the setting 'mongos_host'" &&
    exit
    [[ "$mongod_host" == "" ]] &&
    echo "Please check your configuration. '' is not a valid value for the setting 'mongod_host'" &&
    exit
    [[ "$mongo_port" == "" ]] &&
    echo "Please check your configuration. '' is not a valid value for the setting 'mongo_port'" &&
    exit
    [[ "$mongo_database" == "" ]] &&
    echo "Please check your configuration. '' is not a valid value for the setting 'mongo_database'" &&
    exit
}

# Displays the help
usage() {
    echo "$global_software_name v$global_software_version"
    echo "Usage: $0 command"
    echo ""
    echo "Commands:"
    echo "    insert-test-data   inserts some data to be used for demo"  #TODO - remove option
    echo "    validate-data      validate data"
    echo ""
}

validate_data() {
      lastTimeStamp=0
      mongo "${mongod_host}:${mongo_port}/local" --eval "var lastTimeStamp=${lastTimeStamp}" --quiet ${validate_data_js} 2>&1 | tee ${output_file}
}

insert_test_data() {
    mongo "${mongos_host}:${mongo_port}/${mongo_database}" --quiet ${insert_test_data_js} 2>&1 | tee ${output_file}
}

# Main function
do_main() {
    # Load default configuration, then override settings with the config file
    global_variables

    [[ -f "$global_config" ]] && source "$global_config" &> /dev/null
    global_variables_check

    # Check for validity of argument
    [[ "$1" != "insert-test-data" ]] && [[ "$1" != "validate-data" ]] &&
    usage &&
    exit

    [[ "$1" == "insert-test-data" ]] &&
    insert_test_data &&
    exit

    [[ "$1" == "validate-data" ]] &&
    validate_data &&
    exit
}

#
# MAIN
# Do not change anything here. If you want to modify the code, edit do_main()
#
do_main $*
