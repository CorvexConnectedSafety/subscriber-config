# Subscriber setup automation
# by George Jones 
# I'll put more stuff in here as I go along.

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

# to-do: run the cgi script and capture the script's output
# parse that output and grab the subscriber ID.
# Stick the subscriber ID into varibale "sid"

echo "Creating database for "$realname
perl /home/dib/scripts-testing/addSubscriber.cgi name=$realname prefix=$subscriber

# change the value of the subscriberID and servicepath in localconfig.ini

sed -i 's/scripts-CUSTOMER/'$subpath'/g' localconfig.ini
sed -i 's/NNN/'$sid'/g' localconfig.ini


