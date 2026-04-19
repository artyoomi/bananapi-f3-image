#!/bin/sh

# <TODO>: add docker support in future
CONT_APP=$(
    if hash podman 2>/dev/null; then
        echo "podman"
    else
        error "No container app found!"
        error "Install podman first."
    fi
)
CONT_IMAGE=bpif3-build
CONT_NAME=bpif3-build

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

info() {
    echo "$1"
}

error() {
    # <TODO>: add red color highlighting in future
    echo "$1"
    exit 1
}

confirm_cont_image_presense() {
    if "${CONT_APP}" image inspect "${CONT_IMAGE}" > /dev/null 2>&1; then
        warn "Image ${CONT_IMAGE} already exists!"
    else
        warn "Image ${CONT_IMAGE} not found, building..."
        ${CONT_APP} image build -t ${CONT_IMAGE} .
    fi
}

start_container() {
    confirm_cont_image_presense

    ${CONT_APP} run --interactive --tty \
        --name "$CONT_NAME" \
        --user "$(id -u):$(id -g)" --userns=keep-id \
        --env HOME="$SRCROOT/poky" \
        --workdir "$SRCROOT/poky" \
        --volume "$SRCROOT":"$SRCROOT" \
        "$CONT_IMAGE" \
        bash -c "$@"
}

remove_container() {
    "$CONT_APP" rm --force --volumes "$CONT_NAME" >/dev/null
}
trap remove_container EXIT

case "${BITBAKE_COMMAND}" in
    wrapper)
        start_container "bash"
        ;;
    *)
        echo "Unknown command '${BITBAKE_COMMAND}', available commands: wrapper" >&2
        exit 1
        ;;
esac
