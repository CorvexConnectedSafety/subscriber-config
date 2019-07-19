#!/bin/bash
#Middleware config script

customer=$1
subscribername=$2
sid=$3
url=$customer".corvexconnected.com"

#set up the web app

cp -a /var/www/MASTER /var/www/$customer.corvexconnected.com

#change the .htaccess file in /var/var/www/$customer.corvexconnected.com/html/.htaccess

sed -i 's/SUBSCRIBERID/'$sid'/g' /var/www/$customer.corvexconnected.com/html/.htaccess
sed -i 's/CUSTOMER/'$customer'/g' /var/www/$customer.corvexconnected.com/html/.htaccess
sed -i 's/SUBSCRIBER NAME/'$subscribername'/g' /var/www/$customer.corvexconnected.com/html/.htaccess

# set up Apache
echo "Setting up Apache for the new customer"
cp -a /etc/apache2/sites-available/MASTER /etc/apache2/sites-available/$customer.corvexconnected.com

#edit the config file and change the CUSTOMER name to the name entered on the command line
echo "editing the apache config file"
sed -i 's/CUSTOMER/'$customer/'g' /etc/apache2/sites-available/$customer.corvexconnected.com

# enable the site
echo "Enabling the site"
a2ensite $url

# set up the cert
echo "Setting up the certificate"
certbot -d $url

echo "Middleware completed"
