#! /bin/bash

s3_bucket="upgrad-divya"
myname="divya"
timestamp=$(date '+%d%m%Y-%H%M%S')


sudo apt-get update
sudo apt-get install apache2

sudo systemctl is-active --quiet apache2 || apache2 start
sudo systemctl enable apache2

cd /tmp

sudo tar -cvf ${myname}-httpd-logs-${timestamp}.tar /var/log/apache2/

sudo aws s3 cp /tmp/${myname}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar

exit


