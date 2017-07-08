#!/bin/env bash

#add vhost configuration template
cp /docker/configuration/nginx/default.conf /etc/nginx/conf.d/default.conf

#add php configuration template
cp /docker/configuration/php/php.ini /etc/php/php.ini

#add php-fpm configuration template
cp /docker/configuration/php-fpm/php-fpm.conf /etc/php/php-fpm.conf

#add osticket configuration
cp /docker/configuration/osticket/msmtp.default /etc/msmtp.default

for var in $(printenv); do

    #explode vars to retrive key/value pairs
    IFS='=' read -r -a array <<< $var

    export KEY=${array[0]}

    if [[ $KEY =~ VHOST_|PHP_|FPM_ ]]; then

        export VALUE=${array[1]}

        sed -i -e 's|<'$KEY'>|'$VALUE'|g' '/etc/nginx/conf.d/default.conf'
        sed -i -e 's|<'$KEY'>|'$VALUE'|g' '/etc/php/php.ini'
        sed -i -e 's|<'$KEY'>|'$VALUE'|g' '/etc/php/php-fpm.conf'

    fi

done