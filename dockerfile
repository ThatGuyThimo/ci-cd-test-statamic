# Stage 1: build assets
FROM node:22-alpine as node_builder
WORKDIR /var/www/html
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: install PHP deps
FROM php:8.2-fpm-alpine as php_builder
WORKDIR /var/www/html
RUN docker-php-ext-install pdo pdo_mysql bcmath
COPY --from=node_builder /var/www/html/public/build ./public/build
COPY composer.* ./
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
  && composer install --no-dev --optimize-autoloader

# Stage 3: production image
FROM php:8.2-fpm-alpine
WORKDIR /var/www/html
COPY --from=php_builder /var/www/html ./
COPY . .
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 9000
CMD ["php-fpm"]
