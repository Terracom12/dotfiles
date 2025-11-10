#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

info() {
    >&2 echo -e "${BLUE}"
    >&2 echo -n "$@"
    >&2 echo -e "${NC}"
}

warn() {
    >&2 echo -e "${YELLOW}"
    >&2 echo -n "$@"
    >&2 echo -e "${NC}"
}

err() {
    >&2 echo -en "${RED}"
    >&2 echo -n "$@"
    >&2 echo -e "${NC}"
}

exiterr() {
    code="$1"
    shift
    [[ $# -gt 0 ]] && err "$@"
    exit "$code"
}

debugmsg() {
    [[ $DEBUG ]] || return

    >&2 echo -en "${CYAN}[ ${RED}!!DEBUG MESSAGE!!${CYAN} ]  "
    >&2 echo -n "$@"
    >&2 echo -e "${NC}"
}

reterr() {
    code="$1"
    shift
    [[ $# -gt 0 ]] && err "$@"
    return "$code"
}
