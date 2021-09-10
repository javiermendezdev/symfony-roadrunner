#!/bin/bash

#set -x

envsubst < /docker-utilities/phpini/php.ini.template > /usr/local/etc/php/conf.d/php.ini

# Configure .env.local.php (performance) after create .env from Configserver:
php -d memory_limit=-1 ${COMPOSER_PATH} dump-env ${APP_ENV} --no-cache


if [ "$XDEBUG_ACTIVATED" = true ] ; then
    echo "[ENTRYPOINT] Enable xdebug php.ini package"
    envsubst < /docker-utilities/phpini/xdebug.ini.template > /docker-utilities/phpini/xdebug.ini
    cp /docker-utilities/phpini/xdebug.ini /usr/local/etc/php/conf.d
fi

# if [ "$APP_EXECUTE_MIGRATIONS" = "true" ]; then

#     #echo "[ENTRYPOINT] Update mongodb schema:"
#     #php /var/www/app/bin/console doctrine:mongodb:schema:update --no-interaction
#     # if [ $? -ne 0 ]; then
#     #     echo "[ENTRYPOINT] ERROR: Mongodb Schema update can't be executed." > /dev/stderr
#     #     exit 1
#     # fi

#     # echo "[ENTRYPOINT] Execute migrations"
#  	# php /var/www/app/bin/console doctrine:migrations:migrate --no-interaction
#  	# if [ $? -ne 0 ]; then
#     #     echo "[ENTRYPOINT] ERROR: Migrations can't be executed." > /dev/stderr
#     #     exit 1
#     # fi
# fi


# Launch roadrunner with local config
# TODO: move config to folder docker/{env}
bin/rr serve -c .rr.dev.yaml