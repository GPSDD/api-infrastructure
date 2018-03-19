#!/bin/bash
set -e

case "$1" in
    start)
        echo "Start cron"
        crontab /etc/cron.d/cron
        cron && tail -f /var/log/cron.log
        ;;
    *)
        exec "$@"
esac
