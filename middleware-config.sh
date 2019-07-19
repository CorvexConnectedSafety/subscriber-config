#!/bin/bash
#Middleware config script
# usage: ./middleware-config.sh <subscriber name> <sid>
# 
# Note: sid = Subscriber ID from subscriber-config.sh with the leading 0 removed
# to-do, take into account for 3-digit subscriber id's 
# These will be collected from the subscriber-config.sh script that was just run on db1

subscriber=$1
sid=$2
url=$subscriber".corvexconnected.com"

#set up the web app

cp -a /var/www/MASTER /var/www/$url

#change the .htaccess file in /var/var/www/CUSTOMER.corvexconnected.com/html/.htaccess

sed -i 's/SUBSCRIBERID/'$sid'/g' /var/www/$url/html/.htaccess
sed -i 's/CUSTOMER/'$subscriber'/g' /var/www/$url/html/.htaccess
sed -i 's/SUBSCRIBER NAME/'$subscriber'/g' /var/www/$url/html/.htaccess

# set up Apache
echo "Setting up Apache for the new customer"
cp -a /etc/apache2/sites-available/MASTER /etc/apache2/sites-available/$url

#edit the config file and change the CUSTOMER name to the name entered on the command line
echo "editing the apache config file"
sed -i 's/CUSTOMER/'$subscriber/'g' /etc/apache2/sites-available/$url

# enable the site
echo "Enabling the site"
a2ensite $url

# set up the cert
echo "Setting up the certificate"
certbot -d $url

echo "Middleware completed"
