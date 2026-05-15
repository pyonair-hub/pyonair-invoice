FROM php:8.2-apache

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
        git \
        zip \
        unzip \
        libpng-dev \
        libicu-dev \
        libxml2-dev \
        libzip-dev && \
    rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql intl xml opcache zip

# Install composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Configure apache
RUN a2enmod rewrite && \
    sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Use production PHP config
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
    sed -i 's/memory_limit = 128M/memory_limit = 512M/g' "$PHP_INI_DIR/php.ini"

ENV APACHE_DOCUMENT_ROOT="/var/www/html/public"

WORKDIR /var/www/html

# Copy application code
COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction 2>/dev/null || true

# Set permissions
RUN chown -R www-data:www-data var/ 2>/dev/null || true

EXPOSE 80

CMD ["apache2-foreground"]
