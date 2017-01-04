# Create cphalod.service override directory
sudo mkdir -p /etc/systemd/system/cphalod.service.d/

# Create cphalod service override paramaters
sudo cat <<EOT > /etc/systemd/system/cphalod.service.d/override.conf
[Unit]
OnFailure=failover.service
[Service]
Restart=always
ExecStop=/bin/echo "CloudPassage Halo Agent is stopped...spinning up lifeboat"
ExecStopPost=/bin/systemctl status cphalod
EOT

Create cphalod failover service
sudo cat <<EOT > /etc/systemd/system/failover.service
[Unit]
Description=failover handler
OnFailure=cphalod.service
[Service]
Type=forking
Restart=always
ExecStart=/etc/rc.d/init.d/cphalod start
ExecStopPost=/bin/systemctl status failover
EOT

# Reload cphalod service systemd settings
sudo systemctl daemon-reload

# Set cphalod to run on boot up
sudo systemctl enable cphalod.service
