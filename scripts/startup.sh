#!/usr/bin/env bash
#
# based on gitlab.com/olberger/docker-org-teaching-export
# Meant to be invoked with a non-root user to be created

USER=${USER:-root}
HOME=${HOME:-/root}
uid=${UID:-0}
if [ "x$DEBUG" != "x" ]; then
    set -x
    echo "DEBUG: DEBUG = $DEBUG"
    echo "DEBUG: USER = $USER"
    echo "DEBUG: HOME = $HOME"
    echo "DEBUG: UID = $uid"
fi
if [ "$USER" != "root" ]; then
    useradd --home-dir $HOME --shell /bin/bash --uid $uid --user-group --groups adm,sudo $USER
    if [ -z "$PASSWORD" ]; then
        if [ "x$DEBUG" != "x" ]; then
            echo "DEBUG: set default password for user $USER to \"ubuntu\""
        fi
        PASSWORD=ubuntu
    fi
    echo "$USER:$PASSWORD" | chpasswd
fi

chown -R $USER:$USER $HOME

PASSWORD=''

# execute real command
exec $*
