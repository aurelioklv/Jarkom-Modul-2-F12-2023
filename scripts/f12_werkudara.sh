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

# Install Bind9 using apt-get
echo -e "${BG_BLUE}Installing Bind9...${RESET}"

apt-get update
apt-get install -y bind9

if [ $? -eq 0 ]; then
  echo -e "${BG_GREEN}Bind9 installed successfully.${RESET}"
else
  echo -e "${BG_RED}Error installing Bind9.${RESET}"
  exit 1
fi

# Update named.conf.local
echo -e "${BG_BLUE}Updating /etc/bind/named.conf.local ...${RESET}"

cat <<EOF > /etc/bind/named.conf.local
zone "arjuna.f12.com" {
        type slave;
        masters { 192.227.2.3; };
        file "/var/lib/bind/arjuna.f12.com";
};

zone "baratayuda.abimanyu.f12.com" {
        type master;
        file "/etc/bind/baratayuda/abimanyu.f12.com";
};
EOF

if [ $? -eq 0 ]; then
  echo -e "${BG_GREEN}/etc/bind/named.conf.local updated successfully.${RESET}"
else
  echo -e "${BG_RED}Error updating /etc/bind/named.conf.local${RESET}"
  exit 1
fi

# Making directories
echo -e "${BG_BLUE}Configuring files ...${RESET}"
directories=("baratayuda")
base_directory="/etc/bind"

for dir in "${directories[@]}"; do
    mkdir "$base_directory/$dir"
    if [ -d "$base_directory/$dir" ]; then
        echo -e "${BG_GREEN}Directory '$base_directory/$dir' created successfully.${RESET}"
    else
        echo -e "${BG_RED}Failed to create directory '$base_directory/$dir'.${RESET}"
    fi
done

# Making config file

# baratayuda.abimanyu.f12.com
echo -e "${BG_BLUE}Configuring '/etc/bind/baratayuda/abimanyu.f12.com' ...${RESET}"
if [ -d "/etc/bind/baratayuda" ]; then
  cat <<EOF > /etc/bind/baratayuda/abimanyu.f12.com
;
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     baratayuda.abimanyu.f12.com. root.baratayuda.abimanyu.f12.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN	NS	baratayuda.abimanyu.f12.com.
@	IN	A	192.227.3.3
www	IN	CNAME	baratayuda.abimanyu.f12.com.
rjp     IN      A       192.227.3.3
www.rjp IN      CNAME   rjp.baratayuda.abimanyu.f12.com.
@	IN	AAAA	::1
EOF
  echo -e "${BG_GREEN}File '/etc/bind/baratayuda/abimanyu.f12.com' successfully configured.${RESET}"
else
  echo -e "${BG_RED}Directory '/etc/bind/baratayuda' does not exist. Please create it first.${RESET}"
fi


# Editing /etc/bind/named.conf.options
echo -e "${BG_BLUE}Editing /etc/bind/named.conf.options ...${RESET}"
file="/etc/bind/named.conf.options"
keyword="dnssec-validation"

# Use sed to comment lines with // right before the keyword
sed -i "/$keyword/s|^\(.*[^/]\)$keyword|\1//$keyword|" "$file"

# Check if "allow-query" line is already present
if ! grep -q "allow-query { any; };" "$file"; then
    sed -i "/$keyword/a allow-query { any; };" "$file"
fi
echo -e "${BG_GREEN}Done editing /etc/bind/named.conf.options${RESET}"


# Restart Bind9
echo -e "${BG_CYAN}Restarting Bind9.${RESET}"
service bind9 restart

echo -e "${BG_MAGENTA}DONE${RESET}"