#!/bin/sh

CONT_APP=$(
    if hash docker 2>/dev/null; then
        echo "docker"
    else
        error "No container app found!"
        error "Install docker first."
    fi
)
COMPOSE_APP='docker compose'

export BUILD_CONT_NAME=builder
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
export SRCROOT="$(git rev-parse --show-toplevel)"

# Remove last extension (script.sh -> script)
SCRIPT_ABS_PATH=$(basename $0)
BITBAKE_COMMAND=${SCRIPT_ABS_PATH%.*}

SRCROOT="$(git rev-parse --show-toplevel)"

YELLOW='\033[1;33m'
RED='\033[0;31m'
NO_COLOR='\033[0m'

info() { echo "${1}"; }
warn() { echo "${YELLOW}${1}${NO_COLOR}"; }
error() { echo "${RED}${1}${NO_COLOR}"; exit 1; }

COMPOSE_BASE='-f compose.yaml'
COMPOSE_PROXY='-f compose.yaml -f compose.proxy.yaml --profile with-proxy'

test_availability() {
    TEST_URL='https://yoctoproject.org/connectivity.html'

    info "Testing connection to: ${TEST_URL}"
    curl --connect-timeout 2 "${TEST_URL}" >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        warn "Connectivity test failed! Proxy container will be used."
        NEED_PROXY=1
    else
        info "Connectivity test succeed."
        NEED_PROXY=0
    fi
}

start_containers() {
    test_availability
    if [ ${NEED_PROXY} -eq 0 ]; then
        ${COMPOSE_APP} ${COMPOSE_BASE} up --detach --build
    else
        ${COMPOSE_APP} ${COMPOSE_PROXY} up --detach --build
    fi
    ${CONT_APP} attach ${BUILD_CONT_NAME}

}

remove_containers() {
    info "Stopping containers..."
    if [ ${NEED_PROXY} -eq 0 ]; then
        ${COMPOSE_APP} ${COMPOSE_BASE} down --remove-orphans 2>/dev/null
    else
        ${COMPOSE_APP} ${COMPOSE_PROXY} down --remove-orphans 2>/dev/null
    fi
}
trap remove_containers EXIT

case "${BITBAKE_COMMAND}" in
    wrapper)
        start_containers
        ;;
    *)
        echo "Unknown command '${BITBAKE_COMMAND}', available commands: wrapper" >&2
        exit 1
        ;;
esac
