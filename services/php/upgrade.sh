#!/bin/ash

if [ "$(whoami)" != "pterodactyl" ]; then
    echo "Rerunning script as webserver user."
    exec su -c /usr/local/bin/upgrade pterodactyl
fi

echo "!!! PLEASE BACKUP ANY IMPORTANT DATA BEFORE UPGRADING !!!"
echo "Are you sure you want to continue the upgrade script? (Y/n)"
read -n1 run

if [ "$run" = "y" ] || [ "$run" = "Y" ]; then
    echo "Running upgrade script."
    php artisan down

    # Change introduced in 0.7.0.
    echo "Removing cached configuration."
    rm -r bootstrap/cache/*

    echo "Rerunning configuration scripts."
    php artisan p:environment:setup --cache=redis --session=redis --queue=redis \
        --redis-host=redis --redis-pass="" --redis-port=6379

    echo "Removing cached views."
    php artisan view:clear

    echo "Running migrations."
    php artisan migrate --force
    php artisan db:seed --force

    echo "Cleaning up API keys."
    php artisan p:migration:clean-orphaned-keys

    echo "Upgrade complete. Please restart the container to load changes."
    php artisan up
else
    echo "Exiting."
fi
