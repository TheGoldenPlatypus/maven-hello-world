#!/bin/bash


function incrementVersion(){

    version=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout 2>/dev/null)
    patch=$(( $(echo $version | awk -F. '{print $3}') + 1 ))
    new_version=$(echo $version | awk -F. -v patch=$patch '{printf "%d.%d.%d", $1, $2, patch}')
    mvn versions:set -DnewVersion=$new_version -q 2>/dev/null

    echo $new_version
}

function packageApp(){

    local new_version_id

    while true; do
        case "$1" in
        --new_version_id) new_version_id=$2; shift 2;;
        -- ) shift; break ;;
        * ) break ;;
        esac
    done

    cd myapp
    mvn package
    java -cp target/myapp-$new_version_id.jar com.myapp.App
}

function BuildAndPushDockerImage(){

    local new_version_id
    local username

    while true; do
        case "$1" in
        --new_version_id) new_version_id=$2; shift 2;;
        --registery_username) username=$2; shift 2;;
        -- ) shift; break ;;
        * ) break ;;
        esac
    done
    
     cd myapp
     docker build --build-arg VERSION=$new_version_id -t $username/hello-world:$new_version_id .
     docker push $username/hello-world:$new_version_id
}

function PullImageAndRun(){
    
    local new_version_id
    local username

    while true; do
        case "$1" in
        --new_version_id) new_version_id=$2; shift 2;;
        --registery_username) username=$2; shift 2;;
        -- ) shift; break ;;
        * ) break ;;
        esac
    done

    docker pull $username/hello-world:$new_version_id
    docker run --rm $username/hello-world:$new_version_id
}