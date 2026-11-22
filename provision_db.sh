#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get install -y mysql-server

# Прив'язуємо MySQL виключно до IP приватної мережі Vagrant (замість 0.0.0.0)
sudo sed -i "s/^bind-address\s*=.*/bind-address = 192.168.56.10/" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql

# Створюємо базу та користувача, обмежуючи доступ лише підмережею 192.168.56.%
sudo mysql -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;"
sudo mysql -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'192.168.56.%' IDENTIFIED BY '${DB_PASS}';"
sudo mysql -e "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'192.168.56.%';"
sudo mysql -e "FLUSH PRIVILEGES;"
