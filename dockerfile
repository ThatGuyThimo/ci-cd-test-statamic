# # ---------------------------
# # Stage 1: Build Node assets
# # ---------------------------
# FROM node:22-alpine AS node_builder
# WORKDIR /var/www/html

# # Copy only package files for caching
# COPY package.json ./

# RUN npm install

# # Copy frontend code and build
# COPY . .
# RUN npm run build

# # ---------------------------
# # Stage 2: PHP + Composer + Redis server
# # ---------------------------
# FROM php:8.4-fpm-alpine AS php_builder
# WORKDIR /var/www/html

# # Install PHP extensions + Redis extension + Redis server
# RUN apk add --no-cache $PHPIZE_DEPS redis bash \
#     && docker-php-ext-install pdo pdo_mysql bcmath \
#     && pecl install redis \
#     && docker-php-ext-enable redis \
#     && apk del $PHPIZE_DEPS

# # Step 1: copy only composer files for caching
# COPY composer.json composer.lock ./

# # Step 2: install composer dependencies WITHOUT running scripts
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
#     && composer install --no-dev --optimize-autoloader --no-scripts

# # Step 3: copy the rest of the app code
# COPY . .

# # Step 4: copy Node built assets
# COPY --from=node_builder /var/www/html/public/build ./public/build

# # Fix permissions for Laravel/Statamic
# RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# # Expose PHP-FPM port
# EXPOSE 9000
# EXPOSE 6379

# # ---------------------------
# # Entrypoint
# # ---------------------------
# COPY docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
# COPY docker/docker-entrypoint-create-user.php /usr/local/bin/docker-entrypoint-create-user.php
# RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# # Start both Redis and PHP-FPM
# CMD redis-server --bind 127.0.0.1 --daemonize yes && php-fpm

############################################
# Base Image
############################################

# Learn more about the Server Side Up PHP Docker Images at:
# https://serversideup.net/open-source/docker-php/
FROM serversideup/php:8.3-fpm-nginx AS base

# Switch to root before installing our PHPs extensions
USER root
RUN install-php-extensions imagick bcmath intl gd exif

############################################
# Development Image
############################################
FROM base AS development

# We can pass USER_ID and GROUP_ID as build arguments
# to ensure the www-data user has the same UID and GID
# as the user running Docker.
ARG USER_ID
ARG GROUP_ID

# Switch to root so we can set the user ID and group ID
USER root
RUN docker-php-serversideup-set-id www-data $USER_ID:$GROUP_ID  && \
    docker-php-serversideup-set-file-permissions --owner $USER_ID:$GROUP_ID --service nginx

# Switch back to the unprivileged www-data user
USER www-data

############################################
# CI image
############################################
FROM base AS ci

# Sometimes CI images need to run as root
# so we set the ROOT user and configure
# the PHP-FPM pool to run as www-data
USER root
RUN echo "user = www-data" >> /usr/local/etc/php-fpm.d/docker-php-serversideup-pool.conf && \
    echo "group = www-data" >> /usr/local/etc/php-fpm.d/docker-php-serversideup-pool.conf


############################################
# Production Image
############################################
FROM base AS production


# Install Node.js 22
USER root
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm

# Copy application code excluding node_modules
COPY --chown=www-data:www-data . /var/www/html
RUN rm -rf /var/www/html/node_modules

# Install Composer dependencies first (Statamic CLI/assets must exist before asset publishing)
WORKDIR /var/www/html
ENV COMPOSER_ALLOW_SUPERUSER=1
COPY composer.json composer.lock ./
# Install composer dependencies without running post-install scripts during image build
# Post-install scripts (Statamic install/publish) can attempt to contact services like Redis
# which are not available at build time. We skip scripts here and run them at runtime if needed.
# RUN composer install --optimize-autoloader --no-interaction --no-scripts

# Install composer dependencies without running post-install scripts during image build
# Post-install scripts will be executed at container startup by the entrypoint when runtime
# services and filesystem layout are available.
RUN composer install --optimize-autoloader --no-interaction --no-scripts

# Copy entrypoint and make executable (entrypoint will run skipped composer scripts at runtime)
COPY docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Ensure the entrypoint runs before the default command
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Build Statamic CP assets
# RUN php please statamic:build
# RUN php please cp:assets:publish || true

RUN mkdir -p /var/log/nginx && chown -R www-data:www-data /var/log/nginx
# Fix permissions for Statamic storage directory
RUN chown -R www-data:www-data /var/www/html/storage

# Switch to www-data user for the rest of the operations
USER www-data

# Install npm dependencies and build frontend assets
RUN npm install
RUN npm run build

# Ensure Statamic control panel assets are in the right place
RUN ls public/

# Publish Statamic control panel assets (ensure Vite manifest is present)
# RUN php please assets:publish || true
# RUN php please statamic:build
RUN rm -rf node_modules


# Fix permissions for Statamic storage directory

# # Create a directory for Statamic's stache-locks
# RUN mkdir -p /var/www/html/storage/statamic/stache-locks && chown -R www-data:www-data /var/www/html/storage

# Expose port 8080 to match DigitalOcean App Platform config
EXPOSE 8080