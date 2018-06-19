#!/bin/bash
set -e

case "$1" in
    start)
        echo "Start cron"
        /cronjobs/cronjobs.sh
        ;;
    *)
        exec "$@"
esac
