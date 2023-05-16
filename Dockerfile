FROM composer:2.2 as build
WORKDIR /admin
COPY . /admin
RUN composer install

FROM php:8.2-cli
RUN docker-php-ext-install pdo pdo_mysql

EXPOSE 8080
COPY --from=build /admin /var/www/
COPY docker/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY .env.example /var/www/.env
RUN chmod 777 -R /var/www/storage/
RUN echo "Listen 8080" >> /etc/apache2/ports.conf && \
    chown -R www-data:www-data /var/www/ && \
    a2enmod rewrite