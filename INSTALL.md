# Suspicious

IT Threats GeoDashboard

## How to deploy Suspicious

### MaxMind GeoIP framework

0 4 10 * * wget -O */path/to/my/favorite/lib/dir*/GeoIP.dat.gz http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz && gunzip -f */path/to/my/favorite/lib/dir*/GeoIP.dat.gz

5 4 10 * * wget -O */path/to/my/favorite/lib/dir*/GeoLiteCity.dat.gz http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz && gunzip -f */path/to/my/favorite/lib/dir*/GeoLiteCity.dat.gz

10 4 10 * * wget -O */path/to/my/favorite/lib/dir*/GeoIPASNum.dat.gz http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz && gunzip -f */path/to/my/favorite/lib/dir*/GeoIPASNum.dat.gz

#### Run a geoiplookup test with your IP

If you don't have geoiplookup command available on your system, you may try this :

sudo apt-get install geoip-bin

in a terminal, use the following command to check your GeoIP Database is working :

/usr/bin/geoiplookup -f */path/to/my/favorite/lib/dir*/GeoLiteCity.dat *ip*

