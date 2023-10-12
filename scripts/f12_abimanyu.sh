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
nameserver 192.227.2.3  # IP YudhistiraDNSMaster
nameserver 192.227.2.2  # IP WerkudaraDNSSlave
EOF

if [ $? -eq 0 ]; then
  echo -e "${BG_GREEN}resolv.conf updated successfully.${RESET}"
else
  echo -e "${BG_RED}Error updating resolv.conf.${RESET}"
  exit 1
fi

# Install requirements using apt-get
echo -e "${BG_BLUE}Installing requirements...${RESET}"

apt-get update
apt-get install -y apache2 php libapache2-mod-php7.0 wget unzip

if [ $? -eq 0 ]; then
  echo -e "${BG_GREEN}Requirements installed successfully.${RESET}"
else
  echo -e "${BG_RED}Error installing requirements.${RESET}"
  exit 1
fi


# Configure DocumentRoot to /var/www/abimanyu.f12
config_file="/etc/apache2/sites-available/000-default.conf"  # Change this to the actual path of your Apache configuration file
new_document_root="/var/www/abimanyu.f12"
echo -e "${BG_BLUE}Configuring DocumentRoot to $new_document_root ...${RESET}"
sed -i "s|DocumentRoot .*$|DocumentRoot $new_document_root|" "$config_file"
echo -e "${BG_GREEN}DocumentRoot configuration success ...${RESET}"

# Download resources using wget
echo -e "${BG_BLUE}Downloading resources...${RESET}"
wget -O '/var/www/abimanyu.f12.com.zip' 'https://drive.usercontent.google.com/download?id=1a4V23hwK9S7hQEDEcv9FL14UkkrHc-Zc'
echo -e "${BG_GREEN}Download successful ...${RESET}"

echo -e "${BG_BLUE}Unpacking resources...${RESET}"
unzip /var/www/abimanyu.f12.com.zip -d /var/www/
mv /var/www/abimanyu.yyy.com /var/www/abimanyu.f12
rm /var/www/*.zip
echo -e "${BG_GREEN}Unpacking successful...${RESET}"


# Restart Apache2
echo -e "${BG_CYAN}Restarting Apache2.${RESET}"
service apache2 restart

echo -e "${BG_MAGENTA}DONE${RESET}"