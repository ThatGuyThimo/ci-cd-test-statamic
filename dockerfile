# ---------------------------
# Stage 1: Build Node assets
# ---------------------------
FROM node:22-alpine AS node_builder
WORKDIR /var/www/html

# Copy only package files for caching
COPY package.json ./

RUN npm install

# Copy frontend code and build
COPY . .
RUN npm run build

# ---------------------------
# Stage 2: PHP + Composer + Redis server
# ---------------------------
FROM php:8.4-fpm-alpine AS php_builder
WORKDIR /var/www/html

# Install PHP extensions + Redis extension + Redis server
RUN apk add --no-cache $PHPIZE_DEPS redis bash \
    && docker-php-ext-install pdo pdo_mysql bcmath \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del $PHPIZE_DEPS

# Step 1: copy only composer files for caching
COPY composer.json composer.lock ./

# Step 2: install composer dependencies WITHOUT running scripts
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
    && composer install --no-dev --optimize-autoloader --no-scripts

# Step 3: copy the rest of the app code
COPY . .

# Step 4: copy Node built assets
COPY --from=node_builder /var/www/html/public/build ./public/build

# Fix permissions for Laravel/Statamic
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expose PHP-FPM port
EXPOSE 9000
EXPOSE 6379

# ---------------------------
# Entrypoint
# ---------------------------
COPY docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY docker/docker-entrypoint-create-user.php /usr/local/bin/docker-entrypoint-create-user.php
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Start both Redis and PHP-FPM
CMD redis-server --bind 127.0.0.1 --daemonize yes && php-fpm
