# Suspicious

IT Threats GeoDashboard

Demo available here :
http://awstats.linuxtribe.fr/suspicious/

# Features

**Statistic reports** : country, services, targets

**Threat reports** : target, source, geolocalise (country, region, city), service, timelog

**Map features** : drag, zoom, select country, select it threat, drag it threat, disperse it threats (double click)

**Timeline reports** : move backward and forward in time threat database. Selecting a report before going into
timeline mode results into report survey over timeline.

# Technologies

This application has been build on a GNU/Linux environment and may work on any UNIX system suporting
the following technologies. By the way, there may be PATH and perl REGEXP issues with the perl backend
if you try to deploy it on a Windows server.

## Backend

  * fail2ban : used to detect, log and act when malicious activity is detected
  * MaxMind GeoIP : used to get geographic IP details : latitude, longitude, city, region, country
  * perl : used to process strings with perl REGEXP in order to format the data for the frontend,
  this script produce csv files
  * cron : used to update MaxMind GeoIP database and to call backend perl script to push the data to the frontend

## Frontend

  * web server : nginx, lighttpd will serve our static files to end-users internet browsers
  * d3js : this technology will be used to build the Suspicious GeoDashboard interface
  
# How to deploy Suspicious

We first need to put in place the MaxMind GeoIP framework on our backend server. Then we'll configure different
fail2ban nodes to send their logs to our backend server. And after we setup the frontend service with a web
service we will run the backend script that may format your data for the Suspicious frontend.

## MaxMind GeoIP framework

0 4 10 * * wget -O */path/to/my/favorite/lib/dir*/GeoIP.dat.gz http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz && gunzip -f */path/to/my/favorite/lib/dir*/GeoIP.dat.gz

5 4 10 * * wget -O */path/to/my/favorite/lib/dir*/GeoLiteCity.dat.gz http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz && gunzip -f */path/to/my/favorite/lib/dir*/GeoLiteCity.dat.gz

10 4 10 * * wget -O */path/to/my/favorite/lib/dir*/GeoIPASNum.dat.gz http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz && gunzip -f */path/to/my/favorite/lib/dir*/GeoIPASNum.dat.gz

### Run a self test with your IP

If you don't have geoiplookup command available on your system, you may try this :

sudo apt-get install geoip-bin

in a terminal, use the following command to check your GeoIP Database is working :

/usr/bin/geoiplookup -f */path/to/my/favorite/lib/dir*/GeoLiteCity.dat *ip*

## Fail2ban log convergence

There's many options to manage logs over the network. Most elegant would be to route logs thanks to the syslogd service.
I choosed the option to use an ssh tunnel with RSA key auth to transfert the logs from the different fail2ban nodes.
Once a week, after weekly logs rotation, a crontab entry launch the fail2ban log transfert to my backend node :

0 7 * * 1 scp /var/log/fail2ban.log.1 *backend_host*:*/path/to/my/backend/scripts*/*node_name*.fail2ban.log

On the backend node, you may see all your log files in the */path/to/my/backend/scripts* path as *node_name*.fail2ban.log.
When you've got all your files in it, you are ready to configure the Makefile that will allow data formatting for the
frontend.

