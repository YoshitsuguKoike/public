#!/bin/sh

cd ~

echo "セットアップ開始===================="
date

echo "YUMのアップデート==================="

sudo yum -y update

echo "不要なリソースの削除================"

sudo yum -y remove httpd*
sudo yum -y remove php*

echo "PHPとApacheのインストール==========="

sudo yum install php70 php70-cli php70-common php70-devel php70-gd php70-json php70-mbstring php70-mcrypt php70-mysqlnd php70-pdo php70-xml -y


sudo yum -y install httpd24 gcc

sudo yum -y install php70
sudo yum -y install php70-devel
sudo yum -y install php70-bcmath
sudo yum -y install php70-gd
sudo yum -y install php70-mbstring
sudo yum -y install php70-mcrypt
sudo yum -y install php70-pdo
sudo yum -y install php70-xml
sudo yum -y install php70-xmlrpc
sudo yum -y install php7-pear
sudo yum -y install php70-mysqlnd
sudo yum -y install php70-intl

sudo yum -y install php70-pecl-imagick
sudo yum -y install php70-zip
sudo yum -y install git
sudo yum -y install php70-pecl-redis.x86_64
sudo yum -y install php70-pecl-igbinary-devel.x86_64
sudo yum -y install php70-pecl-igbinary-devel.x86_64


echo '' | sudo tee -a /etc/php.ini
echo 'mbstring.language = Japanese' | sudo tee -a /etc/php.ini
echo 'mbstring.internal_encoding = UTF-8' | sudo tee -a /etc/php.ini
echo 'mbstring.http_input = auto' | sudo tee -a /etc/php.ini
echo 'mbstring.http_output = UTF-8' | sudo tee -a /etc/php.ini
echo 'mbstring.encoding_translation = On' | sudo tee -a /etc/php.ini
echo 'mbstring.detect_order = auto' | sudo tee -a /etc/php.ini
echo 'mbstring.substitute_character = none' | sudo tee -a /etc/php.ini
echo 'mbstring.script_encoding = auto' | sudo tee -a /etc/php.ini
echo '' | sudo tee -a /etc/php.ini
echo '[redis]' | sudo tee -a /etc/php.ini
echo 'extension=/usr/lib64/php/7.1/modules/redis.so' | sudo tee -a /etc/php.ini


sudo chown ec2-user /var/www -Rf
sudo chgrp ec2-user /var/www -Rf

sudo service httpd start
sudo chkconfig httpd on

echo “composerのインストール”
cd ~
composer global require "laravel/installer"

echo '' | sudo tee -a ~/.bash_profile
echo 'PATH=$PATH:$HOME/.config/composer/vendor/bin' | sudo tee -a ~/.bash_profile
echo '' | sudo tee -a ~/.bash_profile
echo 'export PATH' | sudo tee -a ~/.bash_profile
source ~/.bash_profile

sudo chown ec2-user -Rf /var/www
sudo chgrp ec2-user -Rf /var/www

echo $PATH

echo “supervisorのセットアップ”
cd ~
sudo yum install -y python-setuptools
sudo easy_install pip
sudo easy_install supervisor
echo_supervisord_conf > ~/supervisord.conf
sudo mv ~/supervisord.conf /etc/supervisord.conf

sudo mkdir /var/run/supervisor -p
sudo chown ec2-user -Rf /var/run/supervisor
sudo chgrp ec2-user -Rf /var/run/supervisor

echo “supervisorのコンフファイルを変更してください。”

echo '' | sudo tee -a /etc/supervisord.conf
echo 'file=/var/run/supervisor/supervisor.sock   ; the path to the socket file' | sudo tee -a /etc/supervisord.conf
echo 'logfile=/var/run/supervisor/supervisord.log ; main log file; default $CWD/supervisord.log' | sudo tee -a /etc/supervisord.conf
echo 'logfile=/var/run/supervisor/supervisord.log ; main log file; default $CWD/supervisord.log' | sudo tee -a /etc/supervisord.conf
echo 'serverurl=unix:///var/run/supervisor/supervisor.sock ; use a unix:// URL  for a unix socket' | sudo tee -a /etc/supervisord.conf

supervisord

sudo chkconfig supervisord on

ps aux | grep supervisor


## composerのインストール
# composer global require "laravel/installer"
# 
## pathを通す 
# PATH=$PATH:$HOME/.config/composer/vendor/bin
# source ~/.bash_profile
# 
# 
# 
