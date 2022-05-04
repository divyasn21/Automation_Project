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

touch /var/www/html/inventory.html
cat > /var/www/html/inventory.html << EOF

<!DOCTYPE html>
<html>
<head>
<style>
table, th, td {
}
th{
  text-align: left;
}

</style>
</head>
<body>

<table style="width:50%">
  <tr>
    <th>LogType</th>
    <th>TimeCreated</th>
    <th>Type</th>
    <th>Size</th>
  </tr>
</table>

</body>
</html>

EOF

echo "<metadata>" > inventory.html

sudo systemctl is-active --quiet cron.service || cron.service start
sudo systemctl enable cron.service

touch /etc/cron.d/automation
cat > /etc/cron.d/automation << EOF
0 0 * * * root /root/Automation_Project/automation.sh
EOF

exit


