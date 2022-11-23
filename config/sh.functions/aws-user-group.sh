#!/bin/bash

# This script creates an AWS user and adds him to the group "developers", "sysadmins" and "admins"
# It also creates an access key for the user and stores it in a file in the current directory
# The script requires the AWS CLI to be installed and configured
function usage {
    echo "Usage: $0 -u <username> -g <group1,group2,group3>"
    echo "Example: $0 -u john -g developers,sysadmins,admins"
    exit 1
}

function create_user {
    aws iam create-user --user-name $1
}

function add_user_to_group {
    aws iam add-user-to-group --user-name $1 --group-name $2
}

function create_access_key {
    aws iam create-access-key --user-name $1 > $2
}

function main {
    while getopts ":u:g:" opt; do
        case $opt in
            u)
                username=$OPTARG
                ;;
            g)
                groups=$OPTARG
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                usage
                ;;
            :)
                echo "Option -$OPTARG requires an argument." >&2
                usage
                ;;
        esac
    done

    if [ -z "$username" ] || [ -z "$groups" ]; then
        usage
    fi

    create_user $username
    for group in $(echo $groups | sed "s/,/ /g")
    do
        add_user_to_group $username $group
    done
    create_access_key $username $username.json
}

main "$@"