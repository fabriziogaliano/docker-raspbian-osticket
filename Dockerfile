FROM sdhibit/rpi-raspbian:jessie

# Base ENV
ENV APP_CWD='/app/code' \
APP_USER='www-data' \
APP_GROUP='www-data' \
VHOST_ROOT='/app/code' \
VHOST_INDEX='index.php' \
VHOST_TRYFILES='try_files $uri $uri/ /index.php?$query_string;' \
PHP_MAXEXECUTIONTIME='30' \
PHP_MEMORYLIMIT='128M' \
PHP_DISPLAYERRORS='Off' \
PHP_DISPLASTARTUPERRORS='Off' \
PHP_ERRORREPORTING='E_ALL & ~E_DEPRECATED & ~E_STRICT' \
PHP_VARIABLESORDER='GPCS' \
PHP_POSTMAXSIZE='8M' \
PHP_UPLOADMAXFILESIZE='2M' \
PHP_SHORTOPENTAG='Off' \
FPM_USER='www-data' \
FPM_GROUP='www-data' \
FPM_LISTEN='127.0.0.1:9000' \
FPM_CLEARENV='no'

# Install base software
RUN apt update \
    && apt install -yf \
    git \
    cron \
    supervisor \
    nginx \
    php5-fpm

# Install software dependencies
RUN apt install -yf \
    php5-json \
    php-xml-parser \
    php-zend-xml \
    php-phpdocx \
    phpdox \
    php5-sqlite \
    php-dompdf \
    php5-gd \
    php5-mcrypt \
    php5-curl \
    php5-apcu \
    php5-mysql \
    php5-intl

    # Ubuntu/debian Packages only
    # php-zlib \
    # php-xml \
    # php-phar \
    # php-openssl \
    # php-iconv \
    # php-posix \
    # php-opcache \
    # php-ctype \
    # php-pdo \
    # php-pdo_mysql \
    # php-mysqli \
    # php-pdo_sqlite \
    # php-sqlite3 \
    # php-bcmath \
    # php-dom \
    # php-xmlreader

# CleanUP apt directory
RUN rm -rv /var/lib/apt

RUN mkdir -p /app/code

# Install OSTicket
RUN git clone https://github.com/osTicket/osTicket -b 1.9.x /tmp \
    && cd /tmp \
    && git reset --hard 70898b3 \
    && mv /tmp/osTicket/* /app/code \
    && chown www-data:www-data /app -R

RUN apt remove -yf git

RUN touch /etc/msmtp \
    /etc/osticket.secret.txt \
    /etc/cron.d/osticket \
    && chown www-data:www-data \
    /etc/msmtp \
    /etc/osticket.secret.txt \
    /etc/cron.d/osticket

# Add configuration files
COPY . /docker

# Expose ports
EXPOSE 80 443

ENTRYPOINT ["bash", "/docker/scripts/entrypoint.sh"]
CMD ["start-stack"]

WORKDIR $APP_CWD