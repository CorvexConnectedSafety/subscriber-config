# Subscriber setup automation
# by George Jones for Corvex Connected Safety
# 
# usage: ./subscriber-config <company full name> <prefix/subscriber name>

#!/bin/bash

# grab the subscriber name and set up the scripts directory

realname=$1
subscriber=$2
scriptscustomer="/var/www/db1/scripts-"$subscriber
subpath="scripts-"$subscriber

#confirm the subscriber name and exit if no or invalid input
read -r -p "Configuring client name $subscriber . Is this correct? [y/n] " input
 
case $input in
    [yY][eE][sS]|[yY])
 echo "Yes"
 ;;
    [nN][oO]|[nN])
 echo "exiting";
 exit 1
       ;;
    *)
 echo "Invalid input..."
 exit 1
 ;;
esac

# copy the data from the MASTER directory to the subscriber dir

echo "creating "$scriptscustomer
cp -a /var/www/db1/MASTER $scriptscustomer
echo $scriptscustomer " created"

# Note to anyone using this script: Change the path/to/addSubscriber.cgi in order to use this for testing purposes with non-production files

echo "Creating database for "$realname
perl $scriptscustomer/addSubscriber.cgi name=$realname prefix=$subscriber | sed 1d | jq -r '.subscriber[].subscriberID' > /tmp/sid.txt
read sid < /tmp/sid.txt

# change the value of the subscriberID and servicepath in localconfig.ini

sed -i 's/scripts-CUSTOMER/'$subpath'/g' localconfig.ini
sed -i 's/NNN/'$sid'/g' localconfig.ini

# clean up the file from the temp directory

rm /tmp/sid.txt

# Add the backend to the syncronization tool
echo "Adding backend to the sync tool"

fullsid="000"$sid

#create the lsync config file in the customer name
cp /var/www/lsync.conf.d/MASTER /var/www/lsync.conf.d/$subscriber

#edit the newly created file and update the subscriberID and customer name
sed -i 's/CUSTOMER/'$subscriber'/g' /var/www/lsync.conf.d/$subscriber
sed -i 's/NNNNNN/'$fullsid'/g' /var/www/lsync.conf.d/$subscriber

echo "Backends setup for "$realname" completed. Please restart lsyncd."
