#!/bin/bash

set -x

# Configure .env.local.php (performance) after create .env from Configserver:
php -d memory_limit=-1 ${COMPOSER_PATH} dump-env ${APP_ENV} --no-cache

bin/rr serve -c .rr.dev.yaml