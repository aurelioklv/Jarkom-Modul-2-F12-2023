#!/bin/bash

# Update resolv.conf
echo "Updating resolv.conf..."

cat <<EOF > /etc/resolv.conf
options rotate
nameserver 192.122.1.1
EOF

if [ $? -eq 0 ]; then
  echo "resolv.conf updated successfully."
else
  echo "Error updating resolv.conf."
  exit 1
fi

# Install Bind9 using apt-get
echo "Installing Bind9..."

apt-get update
apt-get install -y bind9

if [ $? -eq 0 ]; then
  echo "Bind9 installed successfully."
else
  echo "Error installing Bind9."
  exit 1
fi
