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
apt-get install -y apache2 nginx php libapache2-mod-php7.0 wget unzip

if [ $? -eq 0 ]; then
  echo -e "${BG_GREEN}Requirements installed successfully.${RESET}"
else
  echo -e "${BG_RED}Error installing requirements.${RESET}"
  exit 1
fi


# Configure /etc/nginx/sites-available/
echo -e "${BG_BLUE}Configuring /etc/nginx/sites-available/...${RESET}"

cat <<EOF > /etc/nginx/sites-available/arjuna.f12.com
server {
    listen 8002;
    server_name arjuna.f12.com;
    location / {
        root /var/www/arjuna.f12;
        index index.html;
    }
}
EOF

mkdir /var/www/arjuna.f12

cat <<EOF > /var/www/arjuna.f12/index.html
Ini adalah Abimanyu
EOF
echo -e "${BG_GREEN}Success configuring arjuna.f12 in /etc/nginx/sites-available/...${RESET}"


# Configure DocumentRoot to /var/www/abimanyu.f12
echo -e "${BG_BLUE} Configuring /etc/apache2/sites-available/000-default.conf ...${RESET}"
cat <<EOF > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        #ServerName www.example.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/abimanyu.f12

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
        ErrorDocument 404 /c403.html
        ErrorDocument 404 /c404.html
        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOF
echo -e "${BG_GREEN} Successful configuring /etc/apache2/sites-available/000-default.conf ...${RESET}"


# Customizing error page
echo -e "${BG_BLUE} Customizing error page ...${RESET}"
touch /var/www/abimanyu.f12/c403.html /var/www/abimanyu.f12/c404.html
cat <<EOF > /var/www/abimanyu.f12/c403.html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error 403 - Forbidden</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
        }
        .container {
            margin-top: 50px;
        }
        h1 {
            font-size: 72px;
            color: #FF0000;
        }
        p {
            font-size: 24px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Error 403, dumbass</h1>
        <p>Forbidden to enter, need permission. you criminal</p>
    </div>
</body>
</html>
EOF
echo -e "${BG_GREEN}c403.html created successfully${RESET}"
cat <<EOF > /var/www/abimanyu.f12/c404.html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error 404 - Page Not Found</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
        }
        .container {
            margin-top: 50px;
        }
        h1 {
            font-size: 72px;
            color: #FF0000;
        }
        p {
            font-size: 24px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Error 404, theres NOTHING</h1>
        <p>Theres nothing here, youre either an idiot or mentally ill</p>
    </div>
</body>
</html>
EOF
echo -e "${BG_GREEN}c404.html created successfully${RESET}"


# Configure .htaccess
echo -e "${BG_BLUE}Configuring .htaccess on /var/www/abimanyu.f12 ...${RESET}"
touch /var/www/abimanyu.f12/.htaccess
cat <<EOF > /var/www/abimanyu.f12/.htaccess
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^([^\.]+)$ $1.php [NC,L]
EOF
echo -e "${BG_BLUE}Configuring .htaccess on /var/www/abimanyu.f12 ...${RESET}"

# Download resources using wget
echo -e "${BG_BLUE}Downloading resources...${RESET}"
wget -O '/var/www/abimanyu.f12.com.zip' 'https://drive.usercontent.google.com/download?id=1a4V23hwK9S7hQEDEcv9FL14UkkrHc-Zc'
echo -e "${BG_GREEN}Download successful ...${RESET}"

echo -e "${BG_BLUE}Unpacking resources...${RESET}"
unzip /var/www/abimanyu.f12.com.zip -d /var/www/
mv /var/www/abimanyu.yyy.com /var/www/abimanyu.f12
rm /var/www/abimanyu.f12.com.zip
echo -e "${BG_GREEN}Unpacking successful...${RESET}"


# Restart Apache2
echo -e "${BG_CYAN}Restarting Apache2.${RESET}"
service apache2 restart

# Restart Nginx
echo -e "${BG_CYAN}Restarting Nginx.${RESET}"
service nginx restart

echo -e "${BG_MAGENTA}DONE${RESET}"