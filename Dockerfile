FROM php:8.0

ARG APCU_VERSION=5.1.17

ENV COMPOSER_PATH=/usr/bin/composer\
    COMPOSER_ALLOW_SUPERUSER=1 \
    APP_NAME=symfony-roadrunner \
    APP_ENV=prod \
    PHPINI_CAFILE= \
    PHPINI_OPCACHE_PRELOAD=/var/www/app/var/cache/prod/App_KernelProdContainer.preload.php

## Needed dependencies:
# libssl-dev -> mongodb
# libicu-dev -> intl
# librabbitmq-dev -> amqp
## php packages:
# intl -> Recommended intl - symfony best performance
# sockets: needed for roadrunner
# amqp -> rabbitmq - async events

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gettext-base \
        libssl-dev \
        libgmp-dev \
        # Utilities:
        vim \
        inetutils-telnet \
        inetutils-ping \
        mariadb-client \
        wget \
        librabbitmq-dev \
        libicu-dev \
    && docker-php-ext-install \
        gmp \
        pdo pdo_mysql \
        intl \
        opcache \
        sockets \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb \
    # TODO add -> amqp
    && echo '' | pecl install -o -f apcu-${APCU_VERSION} redis \
    && pecl clear-cache \
    && docker-php-ext-enable apcu opcache intl

COPY --from=composer:latest /usr/bin/composer ${COMPOSER_PATH}

COPY app /var/www/app

RUN cd /var/www/app && \
    php -d memory_limit=-1 ${COMPOSER_PATH} install --no-dev --no-scripts --no-plugins --prefer-dist --no-progress --no-interaction --optimize-autoloader && \
    php -d memory_limit=-1 ${COMPOSER_PATH} dump-autoload --optimize --no-dev --classmap-authoritative && \
    rm -rf /var/www/app/var && \
    chgrp -R 0 /var/www/app && \
    chmod -R g=u /var/www/app

RUN /var/www/app/vendor/bin/rr get-binary --location /usr/local/bin

COPY docker/prod /docker-utilities
RUN chmod +x /docker-utilities/entrypoint.sh

## Clean
RUN apt autoremove --purge -y  && \
    rm -rf /var/lib/apt/lists/* \
        /var/cache/apt/archives/* \
        /var/tmp/* \
        /tmp/*;


WORKDIR /var/www/app
EXPOSE 8080
ENTRYPOINT ["/docker-utilities/entrypoint.sh"]

# TODO:
# HEALTHCHECK CMD curl -f http://localhost:8080/actuator/healthcheck || exit 1
