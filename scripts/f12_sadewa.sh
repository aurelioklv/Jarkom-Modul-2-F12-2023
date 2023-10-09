#!/bin/bash

cat <<EOF > /etc/resolv.conf
options rotate
nameserver 192.122.1.1
EOF

if [ $? -eq 0 ]; then
  echo "resolv.conf updated successfully."
else
  echo "Error updating resolv.conf."
fi
