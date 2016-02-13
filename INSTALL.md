# Suspicious

IT Threats GeoDashboard

## How to deploy Suspicious

### Architecture

Suspicious may be deployed within a web instance :

/var/www/suspicious.yourdomain.com/frontend (htdocs)

/var/www/suspicious.yourdomain.com/frontend/index.html (d3js)

/var/www/suspicious.yourdomain.com/frontend/img (ui ressources)

/var/www/suspicious.yourdomain.com/frontend/js (ui ressources)

/var/www/suspicious.yourdomain.com/frontend/geo (ui ressources)

/var/www/suspicious.yourdomain.com/frontend/db (timeline csv db)

/var/www/suspicious.yourdomain.com/backend (perl scripts)

### MaxMind GeoIP

Just check your system has wget command installed or install it :

sudo apt-get install wget

There's many way to add crontab entries : users crontab, /etc/cron* files. Here are
entries you may use to update your local GeoIP database :

0 4 10 * * wget -O */path/to/my/favorite/lib/dir*/GeoIP.dat.gz http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz && gunzip -f */path/to/my/favorite/lib/dir*/GeoIP.dat.gz

5 4 10 * * wget -O */path/to/my/favorite/lib/dir*/GeoLiteCity.dat.gz http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz && gunzip -f */path/to/my/favorite/lib/dir*/GeoLiteCity.dat.gz

10 4 10 * * wget -O */path/to/my/favorite/lib/dir*/GeoIPASNum.dat.gz http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz && gunzip -f */path/to/my/favorite/lib/dir*/GeoIPASNum.dat.gz

#### Run a geoiplookup test with your IP

If you don't have geoiplookup command available on your system, you may try this :

sudo apt-get install geoip-bin

in a terminal, use the following command to check your GeoIP Database is working :

/usr/bin/geoiplookup -f */path/to/my/favorite/lib/dir*/GeoLiteCity.dat *ip*

### Get Suspicious

git clone https://github.com/ffrouin/suspicious

cd suspicious

make install SITE_PATH=/var/www/suspicious.yourdomain.com

### Instanciate a web service with nginx, lighttpd or even apache2

End users should not access the backend, this directory can't be a child directory
of your web root directory (htdocs). Backend and Frontend directory may be in the
same directory while Frontend directory will be root directory of your web instance.

### Configure the backend

#### Configure the backend log retriever

#### Configure the backend log processor
