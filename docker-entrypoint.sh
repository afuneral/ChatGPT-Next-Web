#!/bin/sh
set -e

if [ "$TRACE" = "1" ]; then
	set -x
fi

# this if will check if the first argument is a flag
# but only works if all arguments require a hyphenated flag
# -v; -SL; -f arg; etc will work, but not arg1 arg2
if [ "$#" -eq 0 ] || [ "${1#-}" != "$1" ]; then
    set -- ${SERVICE_NAME} "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = "${SERVICE_NAME}" -a "$(id -u)" = '0' ]; then
    # use gosu (or su-exec) to drop to a non-root user
    exec gosu ${SERVICE_NAME} ${BASH_SOURCE} $@
fi

if [ "$1" = "${SERVICE_NAME}" ]; then
    # export EXTERNAL_IP
    if [ -f /etc/fip/fip.data -a -z "$EXTERNAL_IP" ]; then
        export EXTERNAL_IP=$(cat /etc/fip/fip.data)
    fi
    exec ${SERVICE_EXEC_START}
else
    # else default to run whatever the user wanted like "bash" or "sh" or other cmd
    exec "$@"
fi
