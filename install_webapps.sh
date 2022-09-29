#!/bin/bash

sudo dnf install -y glibc-langpack-ja
sudo localectl set-locale LANG=ja_JP.UTF-8
sudo dnf install -y git make patch

sudo dnf install -y mariadb-server mysql-devel
sudo systemctl enable mariadb.service
sudo systemctl start mariadb.service

sudo dnf install -y postgresql-server
if [ ! -e "/var/lib/pgsql/data" ]; then sudo postgresql-setup --initdb; fi
sudo systemctl enable postgresql.service
sudo systemctl start postgresql.service

sudo dnf -y distro-sync
sudo dnf -y module reset php
sudo dnf -y module enable php:7.4
sudo dnf -y distro-sync

sudo dnf install -y httpd httpd-devel mod_ssl
sudo dnf install -y php php-mbstring php-devel php-mhash php-pgsql php-mysqli php-xml php-gd  php-intl php-curl php-zip php-opcache php-pecl-apcu php-pear
sudo systemctl enable httpd.service
sudo systemctl start httpd.service

sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo dnf install -y certbot python3-certbot-apache

sudo sh -c 'echo "#!/bin/sh" > /etc/cron.weekly/certbot_renew'
sudo sh -c 'echo "certbot renew --post-hook \"systemctl reload httpd\"" >> /etc/cron.weekly/certbot_renew'

sudo chmod +x /etc/cron.weekly/certbot_renew

#sudo dnf update -y
