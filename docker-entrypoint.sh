#!/bin/sh
set -e

# Run composer post-autoload-dump scripts safely
composer run-script post-autoload-dump || true

# Run Statamic install only if artisan exists
if [ -f artisan ]; then
    php artisan statamic:install --ansi || true
fi

# Execute the default CMD
exec "$@"
