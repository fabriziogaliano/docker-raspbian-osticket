#!/bin/env bash
#add vhost configuration template
cp /docker/configuration/nginx/default.conf /etc/nginx/sites-available/default
#add php configuration template
cp /docker/configuration/php/php.ini /etc/php5/cli/php.ini
#add php-fpm configuration template
cp /docker/configuration/php-fpm/php-fpm.conf /etc/php5/fpm/php-fpm.conf
#osticket installation and configuration
cp /docker/configuration/osticket/msmtp.default /etc/msmtp.default
### try to beleave ###
touch /etc/osticket.secret.txt
touch /etc/cron.d/osticket
chown www-data:www-data /etc/msmtp.default
chown www-data:www-data /etc/osticket.secret.txt
chown www-data:www-data /etc/cron.d/osticket
###   ###   ###   ###
#environment substitution
for var in $(printenv); do
    #explode vars to retrive key/value pairs
    IFS='=' read -r -a array <<< $var
    export KEY=${array[0]}
    if [[ $KEY =~ VHOST_|PHP_|FPM_ ]]; then
        export VALUE=${array[1]}
        sed -i -e 's|<'$KEY'>|'$VALUE'|g' '/etc/nginx/site-available/default'
        sed -i -e 's|<'$KEY'>|'$VALUE'|g' '/etc/php5/cli/php.ini'
        sed -i -e 's|<'$KEY'>|'$VALUE'|g' '/etc/php5/fpm/php-fpm.conf'
    fi
done