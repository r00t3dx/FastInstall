#!/bin/bash

clear

echo "Update"
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y

echo "Base"
apt-get install git nano make wget sudo apt-transport-https lsb-release ca-certificates locate localepurge systemd nginx fail2ban -y
apt-get purge ntp rsyslog exim* postfix* sendmail* updatedb ldconfig -y

service nginx start

echo "Install Symfony"
wget https://get.symfony.com/cli/installer -O - | bash
mv /root/.symfony/bin/symfony /usr/local/bin/symfony

echo "Install Composer"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer

echo "Install PHP"
apt-get install lsb-release apt-transport-https ca-certificates -y
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
apt-get update
apt-get install php7.4 -y

echo "PHP Packages"
apt-get install php7.4-{fpm,bcmath,bz2,intl,gd,mbstring,mysql,zip,mcrypt,redis,imagick,intl,yaml,xml} -y

echo "Install Redis"
apt-get install redis-server -y
service redis-server start

echo "Install Mysql 8"
cd /tmp
wget https://dev.mysql.com/get/mysql-apt-config_0.8.13-1_all.deb
dpkg -i mysql-apt-config*
rm -rf mysql-apt-config_0.8.13-1_all.deb
apt update
apt install mysql-server -y

service --status-all

history -c
