#!/bin/env bash

if [ "$1" = "start-stack" ]; then

    #bootloading for configuration
    /bin/bash /docker/scripts/bootloader.sh

    #call supervisord to launch the whole stack
    /usr/bin/supervisord --nodaemon --configuration=/docker/configuration/supervisord/supervisor.conf

fi