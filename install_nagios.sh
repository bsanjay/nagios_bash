#!/bin/bash

#Refernce URL
#https://linuxize.com/post/how-to-install-and-configure-nagios-on-centos-7/

#Disable SELinux or set in permissive mode as instructed here .
#Update your CentOS system and install Apache , PHP and all the packages necessary to download and compile the Nagios main application and Nagios plugins:

sudo yum update -y
sudo yum install httpd php php-cli gcc glibc glibc-common gd gd-devel net-snmp openssl-devel wget -y
sudo yum install make gettext autoconf net-snmp-utils epel-release perl-Net-SNMP postfix unzip automake -y

#Perform the following steps to install the latest version of Nagios Core from source.
cd /usr/src/
#Download the latest version of Nagios from the project Github repository using the following wget command :
sudo wget https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.2.tar.gz
#Once the download is complete extract the tar file with:
sudo tar zxf nagios-*.tar.gz
#Before continuing with the next steps, make sure you change to the Nagios source directory by typing:
cd nagioscore-nagios-*/
#To start the build process run the configure script which will perform a number of checks to make sure all of the dependencies on your system are present:
sudo ./configure
#Start the compilation process using the make command:
sudo make all
#Create a new system nagios user and group by issuing:
sudo make install-groups-users
groupadd -r nagios
useradd -g nagios nagios
#Add the Apache apache user to the nagios group:
sudo usermod -a -G nagios apache
#Run the following command to install Nagios binary files, CGIs, and HTML files:
sudo make install
#Nagios can process commands from external applications. Create the external command directory and set the proper permissions by typing:
sudo make install-commandmode
#Install the sample Nagios configuration files with:
sudo make install-config
#Run the command below to install the Apache web server configuration files:
sudo make install-webconf
#Restart the web server:
sudo systemctl restart httpd
#The following command installs a systemd unit file and also configure the nagios service to start on boot.
sudo make install-daemoninit
#To be able to access the Nagios web interface wel’ll create an admin user called nagiosadmin
#pass the password with option -b to avoid passowrd prompt
sudo htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin nagiosadmin
#Restart the Apache service for changes to take effect:
sudo systemctl restart httpd
#Configure the Apache service to start on boot.
sudo systemctl enable httpd

#Installing Nagios Plugins
cd /usr/src/
#Download the latest version of the Nagios Plugins from the project Github repository : https://github.com/nagios-plugins/nagios-plugins/
sudo wget -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz
#When the download is complete extract the tar file:
sudo tar zxf nagios-plugins.tar.gz
#Change to the plugins source directory:
cd nagios-plugins-release-2.2.1
#Run the following commands one by one to compile and install the Nagios plugins:
sudo ./tools/setup
sudo ./configure
sudo make
sudo make install
#Now that both Nagios and its plugins are installed, start the Nagios service with:
sudo systemctl start nagios
#To verify that Nagios is running, check the service status with the following command:
sudo systemctl status nagios
#Configure the nagios service to start on boot.
sudo systemctl enable nagios

#To access the Nagios web interface open your favorite browser and type your server’s domain name or public IP address followed by /nagios:
echo "http(s)://your_domain_or_ip_address/nagios"
echo "THANK YOU"
