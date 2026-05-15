FROM php:8.4-apache

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
        git \
        zip \
        unzip \
        libpng-dev \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
        libicu-dev \
        libxml2-dev \
        libzip-dev \
        libcurl4-openssl-dev \
        libonig-dev \
        libxslt1-dev \
        libxml2-dev \
        curl \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install PHP extensions (including soap, xsl required by SolidInvoice)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) pdo pdo_mysql intl xml opcache zip gd curl mbstring bcmath soap xsl

# Install Redis extension via PECL
RUN pecl install redis && docker-php-ext-enable redis

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

# Install Symfony CLI (needed for post-install scripts)
RUN curl -sS https://get.symfony.com/cli/installer | bash && \
    mv /root/.symfony*/bin/symfony /usr/local/bin/symfony 2>/dev/null || true

# Create .env for Symfony with prod settings
RUN cp .env.dist .env 2>/dev/null || echo "SOLIDINVOICE_ENV=prod" > .env && \
    sed -i 's/^SOLIDINVOICE_ENV=.*/SOLIDINVOICE_ENV=prod/' .env && \
    sed -i 's/^SOLIDINVOICE_DEBUG=.*/SOLIDINVOICE_DEBUG=0/' .env && \
    cat .env | head -5

# Set prod environment for Symfony kernel (avoids loading dev bundles)
ENV APP_ENV=prod
ENV SOLIDINVOICE_ENV=prod
ENV COMPOSER_ALLOW_SUPERUSER=1

# Install dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Clear any dev cache and warm up prod cache
RUN php bin/console cache:clear --env=prod --no-debug 2>/dev/null || true && \
    php bin/console cache:warmup --env=prod --no-debug 2>/dev/null || true

# Set permissions
RUN chown -R www-data:www-data var/ 2>/dev/null || true && \
    chmod -R 777 var/ 2>/dev/null || true

EXPOSE 80

# Entrypoint for runtime setup
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
