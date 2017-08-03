# How to deploy Suspicious GeoDashboard

## Install package required to satisfy functional dependencies

	sudo apt-get install geoip-bin wget unzip

## Download the suspicious debian package

	wget https://github.com/ffrouin/suspicious/raw/master/suspicious_0.2-1_all.deb

## Install suspicious

	sudo dpkg -i suspicious_0.2-1_all.deb

Here is the detail of what is installed :

	User account : suspicious (home -> /var/lib/suspicious)
	Crontab : /etc/cron.d/suspicious (GeoIP DB update && report build on monday morning)
	Static data : /usr/share/suspicious
	Live data : /var/lib/suspicious/db
	Log : /var/log/fail2ban.log (/etc/logrotate.conf/suspicious)

## Update your suspicious db with your latest fail2ban data

	sudo su - suspicious
	export PERL5LIB=/usr/share/suspicious/backend/lib && /usr/share/suspicious/backend/suspicious.pl

## Configure your web service for suspicious

The package provides sample of configuration for apache2, lighttpd and nginx.

### Apache2

	sudo ln -s /usr/share/suspicious/apache/suspicious.conf /etc/apache2/conf-enabled/suspicious.conf
	sudo service apache2 restart

### Lighttpd

	sudo ln -s /usr/share/suspicious/lighttpd/suspicious.conf /etc/lighttpd/conf-enabled/suspicious.conf
	sudo service lighttpd restart

### Nginx

	sudo ln -s /usr/share/suspicious/nginx/suspicious.conf /etc/nginx/conf.d/suspicious.conf
	sudo service nginx restart

## Access your dashboard

	http://localhost/suspicious

You can browse db made of CSV files if you need to access raw data :

	http://localhost/suspicious/db

# Manage multiple sources to integrate IT Threat Reports

## Generate ssh key pair for suspicious user

	sudo su - suspicious
	ssh-keygen

Copy content of this file :

	/var/lib/suspicious/.ssh/id_rsa.pub

## On different sources publish RSA public key

You may choose a system account able to read /var/log/fail2ban.log.1 (adm group) or you may change mask in /etc/logrotate.d/fail2ban.

Paste RSA public key to file :

	$HOME/.ssh/authorized_keys

## Include different sources to suspicious backend

	vi /etc/suspicious/backend.conf

	;node			collector	processor	tag		file
	<user>@<remote_host>	scp		fail2ban	<report_host_name>	/var/log/fail2ban.log.1

## Update your suspicious db with your latest fail2ban data

	sudo su - suspicious
	export PERL5LIB=/usr/share/suspicious/backend/lib && /usr/share/suspicious/backend/suspicious.pl

## Access your dashboard

	http://localhost/suspicious

You can browse db made of CSV files if you need to access raw data :

	http://localhost/suspicious/db
