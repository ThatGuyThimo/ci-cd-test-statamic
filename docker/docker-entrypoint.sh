#!/bin/sh
set -e

# Move to app root
# cd "$(dirname "$0")/.."
cd /var/www/html

# Run composer post-autoload-dump scripts safely
composer run-script post-autoload-dump || true

# Run Statamic install only if artisan exists
if [ -f artisan ]; then
    php artisan statamic:install --ansi || true
fi

# Seed default user only if no users exist
if [ ! -d "content/users" ] || [ -z "$(ls -A content/users)" ]; then
    echo "Seeding default admin user..."
    php docker/docker-entrypoint-create-user.php
else
    echo "Users already exist, skipping seeding."
fi

# Execute the default CMD
exec "$@"
