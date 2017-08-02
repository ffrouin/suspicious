# How to deploy Suspicious GeoDashboard

## First install package required to satisfy functional dependencies

	sudo apt-get install apache2 fail2ban geoip-bin wget unzip

## Then download the suspicious debian package

	wget https://github.com/ffrouin/suspicious/raw/master/suspicious_0.1-1_all.deb
	sudo dpkg -i suspicious_0.1-1_all.deb

Here is the details of what is installed :

	User account : suspicious (home -> /var/lib/suspicious)
	User crontab : GeoIP DB update && report build on monday morning
	Suspicious static data : /usr/share/suspicious
	Suspicious user data : /var/lib/suspicious/db
	Apache2 setup : /etc/apache2/enabled-conf/suspicious.conf
	Log : /var/log/fail2ban.log (/etc/logrotate.conf/suspicious)

## Update your suspicious db with your latest fail2ban data

	sudo su - suspicious
	export PERL5LIB=/usr/share/suspicious/backend/lib && /usr/share/suspicious/backend/suspicious.pl

## Access your dashboard

	http://localhost/suspicious

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

