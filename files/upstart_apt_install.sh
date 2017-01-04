# Create Upstart Persistent Job File
sudo cat <<EOT > /etc/init/cphalod.conf
description "A job file that keeps cphalod running persistently"
author "CloudPassage Integration"

start on runlevel [2345]
stop on runlevel [016]

respawn

exec start-stop-daemon --start --name cphalod --exec /opt/cloudpassage/bin/cphalo --pidfile=/opt/cloudpassage/data/halo.pid

pre-stop script
        start
end script
EOT