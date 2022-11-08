#!/bin/bash

FQDN=$1
USERNAME=$2
STAGING=$3

sudo dnf install -y glibc-langpack-ja
sudo localectl set-locale LANG=ja_JP.UTF-8
sudo dnf install -y git make patch rsync
sudo timedatectl set-timezone Asia/Tokyo

sudo dnf install -y mariadb-server mysql-devel
sudo systemctl enable mariadb.service
sudo systemctl start mariadb.service

sudo dnf -y module reset php
sudo dnf -y module enable php:7.4

sudo dnf -y module reset postgresql
sudo dnf -y module enable postgresql:12

sudo dnf install -y postgresql-server
if [ ! -e "/var/lib/pgsql/data" ]; then sudo postgresql-setup --initdb; fi
sudo systemctl enable postgresql.service
sudo systemctl start postgresql.service

sudo dnf install -y httpd httpd-devel mod_ssl
sudo dnf install -y php php-mbstring php-devel php-mhash php-pgsql php-mysqli php-xml php-gd  php-intl php-curl php-zip php-opcache php-pecl-apcu php-pear
sudo systemctl enable httpd.service
sudo systemctl start httpd.service

sudo sed -i -e 's/memory_limit = 128M/memory_limit = 384M/' /etc/php.ini
sudo sed -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 50M/' /etc/php.ini
sudo sed -i -e 's/post_max_size = 8M/post_max_size = 50M/' /etc/php.ini
sudo sed -i -e 's/expose_php = On/expose_php = Off/' /etc/php.ini

sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo dnf install -y certbot python3-certbot-apache

sudo sh -c 'echo "#!/bin/sh" > /etc/cron.weekly/certbot_renew'
sudo sh -c 'echo "certbot renew --post-hook \"systemctl reload httpd\"" >> /etc/cron.weekly/certbot_renew'

sudo chmod +x /etc/cron.weekly/certbot_renew

#sudo dnf -y distro-sync

sudo mkdir -p /var/www/html/${FQDN}/html
sudo mkdir -p /var/www/html/${STAGING}.${FQDN}/html

sudo chown ${USERNAME}:${USERNAME} -R /var/www/html

sudo sh -c "cat <<EOF > /etc/httpd/conf.d/${FQDN}.conf
ServerTokens Prod
<Directory /var/www/html/${FQDN}>
    Options MultiViews SymLinksIfOwnerMatch IncludesNoExec
    AllowOverride All
    Require all granted
    DirectoryIndex index.html index.htm index.php
</Directory>
<Directory /var/www/html/${FQDN}/html/upload>
    <FilesMatch \\.(php|phar)\$>
        SetHandler None
    </FilesMatch>
    AllowOverride None
</Directory>
<VirtualHost *:80>
    ServerName     ${FQDN}
    ServerAdmin    webmaster@${FQDN}
    DocumentRoot   /var/www/html/${FQDN}/html
    CustomLog      logs/${FQDN}-access_log combined
    ErrorLog       logs/${FQDN}-error_log
    Header unset X-Powered-By
</VirtualHost>
EOF"

sudo sh -c "cat <<EOF > /etc/httpd/conf.d/${STAGING}.${FQDN}.conf
<Directory /var/www/html/${STAGING}.${FQDN}>
    Options MultiViews SymLinksIfOwnerMatch IncludesNoExec
    AllowOverride All
    Require all granted
    DirectoryIndex index.html index.htm index.php
</Directory>
<Directory /var/www/html/${STAGING}.${FQDN}/html/upload>
    <FilesMatch \\.(php|phar)\$>
        SetHandler None
    </FilesMatch>
    AllowOverride None
</Directory>
<VirtualHost *:80>
    ServerName     ${STAGING}.${FQDN}
    ServerAdmin    webmaster@${FQDN}
    DocumentRoot   /var/www/html/${STAGING}.${FQDN}/html
    CustomLog      logs/${STAGING}.${FQDN}-access_log combined
    ErrorLog       logs/${STAGING}.${FQDN}-error_log
    Header unset X-Powered-By
</VirtualHost>
EOF"

sudo sh -c "cat <<EOF > /etc/httpd/conf.d/dirs.conf
<DirectoryMatch \.git>
    Require all denied
</DirectoryMatch>
<FilesMatch \.env>
    Require all denied
</FilesMatch>
EOF"

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --install-dir=/usr/bin --filename=composer
rm composer-setup.php
