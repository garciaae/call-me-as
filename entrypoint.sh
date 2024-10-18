#!/bin/bash

set -e

export path_project=/twilio

case $1 in
    run-bash)
        echo "--> Starting bash"
        exec /bin/bash
        ;;
    run-init)
        echo "--> Initializing project"
        exec mkdir -p /twilio/profile
        ;;
    *)
        exec "$@"
        ;;
esac
