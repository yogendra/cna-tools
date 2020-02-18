#!/usr/bin/env bash
JSON="{"

function add_version {
    PROD=$1
    VERSION=$2
    JSON_ELEMENT="\"${PROD}\": \"${VERSION}\""
    if [[ $JSON != "{" ]]; then
        JSON="${JSON},"
    fi
    JSON="$JSON
    ${JSON_ELEMENT}"
}


add_version "pivotal-function-service" "alpha v0.4.0"
add_version "pivotal-container-service" "1.6.1"
add_version "p-scheduler" "1.2.28"
add_version "pcf-app-autoscaler" "2.0.199"
add_version "p-event-alerts" "1.2.8"
add_version "terraform" "0.11.14"
add_version "riff" "v0.4.0"
add_version "cf" "$(wget ${GITHUB_OPTIONS} -qO- https://api.github.com/repos/cloudfoundry/cli/releases/latest  | jq -r '.tag_name' | sed s/^v// )"
add_version "docker" "$(wget ${GITHUB_OPTIONS} -qO- https://api.github.com/repos/docker/docker-ce/releases/latest  | jq -r '.tag_name'   | sed s/^v//)"

JSON="$JSON
}"

echo "$JSON" | jq -S

