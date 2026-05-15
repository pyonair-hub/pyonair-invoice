#!/bin/bash
set -e

# Ensure var directories are writable
chown -R www-data:www-data /var/www/html/var 2>/dev/null || true
chmod -R 775 /var/www/html/var 2>/dev/null || true

# Run database migrations if DATABASE_URL is set
if [ -n "$DATABASE_URL" ]; then
    php bin/console doctrine:migrations:migrate --no-interaction 2>/dev/null || echo "Migration failed - database may not be ready"
fi

exec "$@"
