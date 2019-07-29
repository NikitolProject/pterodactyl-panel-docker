FROM php:7.2-fpm-alpine

ENV PANEL_VERSION=v0.7.14

# Set up all the dependencies for the PHP container.
RUN apk add --no-cache curl git supervisor tar unzip; \
    docker-php-ext-install bcmath; \
    apk add --no-cache libpng-dev; \
    docker-php-ext-install gd; \
    docker-php-ext-install mbstring; \
    docker-php-ext-install pdo; \
    docker-php-ext-install pdo_mysql; \
    docker-php-ext-install tokenizer; \
    apk add --no-cache libxml2-dev; \
    docker-php-ext-install xml; \
    docker-php-ext-install zip; \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set up the server working directories.
RUN adduser -g '' -D -u 9999 pterodactyl; \
    mkdir -p /var/www/html/env; \
    mkdir -p /var/www/html/pterodactyl

WORKDIR /var/www/html/pterodactyl
RUN chown -R pterodactyl:pterodactyl /var/www/html/pterodactyl /var/www/html/env

# Deploy panel files.
USER pterodactyl:pterodactyl
RUN curl -Lo panel.tar.gz https://github.com/Pterodactyl/Panel/releases/download/${PANEL_VERSION}/panel.tar.gz; \
    tar --strip-components=1 -xzvf panel.tar.gz; \
    cp .env.example /var/www/html/env/.env; \
    ln -s /var/www/html/env/.env /var/www/html/pterodactyl/.env; \
    composer install --no-dev --optimize-autoloader; \
    chmod -R 755 storage/* bootstrap/cache

# Copy the remaining configuration files.
USER root:root
RUN mkdir -p /var/log/pterodactyl

COPY install.sh /usr/local/bin/install
COPY upgrade.sh /usr/local/bin/upgrade
COPY schedule /var/spoon/cron/crontabs/schedule
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY www.conf /usr/local/etc/php-fpm.d/www.conf

RUN chmod +x /usr/local/bin/install; \
    chmod +x /usr/local/bin/upgrade

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
