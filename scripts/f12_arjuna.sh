#!/bin/bash

# ANSI escape codes for foreground colors
FG_BLACK="\e[30m"
FG_RED="\e[31m"
FG_GREEN="\e[32m"
FG_YELLOW="\e[33m"
FG_BLUE="\e[34m"
FG_MAGENTA="\e[35m"
FG_CYAN="\e[36m"
FG_WHITE="\e[37m"
FG_RESET="\e[39m"

# ANSI escape codes for background colors
BG_BLACK="\e[40m"
BG_RED="\e[41m"
BG_GREEN="\e[42m"
BG_YELLOW="\e[43m"
BG_BLUE="\e[44m"
BG_MAGENTA="\e[45m"
BG_CYAN="\e[46m"
BG_WHITE="\e[47m"

# Reset formatting to default
RESET="\e[0m"

# Update resolv.conf
echo -e "${BG_BLUE}Updating resolv.conf...${RESET}"

cat <<EOF > /etc/resolv.conf
options rotate
nameserver 192.122.1.1
EOF

if [ $? -eq 0 ]; then
  echo -e "${BG_GREEN}resolv.conf updated successfully.${RESET}"
else
  echo -e "${BG_RED}Error updating resolv.conf.${RESET}"
  exit 1
fi

# Install Nginx using apt-get
echo -e "${BG_BLUE}Installing Nginx...${RESET}"

apt-get update
apt-get install -y nginx

if [ $? -eq 0 ]; then
  echo -e "${BG_GREEN}Nginx installed successfully.${RESET}"
else
  echo -e "${BG_RED}Error installing Nginx.${RESET}"
  exit 1
fi

# Configuring load-balancer.conf
echo -e "${BG_BLUE}making /etc/nginx/conf.d/load-balancer.conf...${RESET}"

cat <<EOF > /etc/nginx/conf.d/load-balancer.conf
upstream backend {
    server 192.227.3.2:8001;
    server 192.227.3.3:8002;
    server 192.227.3.4:8003;
}

server {
    listen 80;
    server_name arjuna.f12.com;

    location / {
        proxy_pass http://www.arjuna.f12.com;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF
echo -e "${BG_GREEN}File '/etc/nginx/conf.d/load-balancer.conf' successfully configured.${RESET}"


# Restart Nginx
echo -e "${BG_CYAN}Restarting Nginx.${RESET}"
service nginx restart

echo -e "${BG_MAGENTA}DONE${RESET}"
