# create /etc/init.conf
sudo touch /etc/init.conf

# Create Upstart Persistent Job File
sudo cat <<EOT > /etc/init/cphalod.conf
description "A job file that keeps cphalod running persistently"
author "CloudPassage Integration"

start on runlevel [2345]
stop on runlevel [016]

respawn

exec /opt/cloudpassage/bin/cphalo --pidfile=/var/run/cphalod.pid

pre-stop script
        start
end script
EOT

# start the daemon for the first time
initctl start cphalod