# Subscriber setup automation
# by George Jones
# I'll put more stuff in here as I go along.

#!/bin/bash

# grab the subscriber name and set up the scripts directory

subscriber=$1
scriptscustomer="/var/www/db1/scripts-"$subscriber

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
echo "yes selected"
echo "creating "$scriptscustomer

cp -a /var/www/db1/MASTER $scriptscustomer

echo $scriptscustomer " created"

#run the perl script and capture the generated subscriber ID

