check:
	whereis wget
	whereis gunzip
	whereis geoiplookup

install:
	cp -r frontend $(SITE_PATH)/
	ln -s $(SITE_PATH)/frontend $(SITE_PATH)/htdocs
	cp -r backend $(SITE_PATH)/

maxmind:
	wget -O /usr/lib/maxmind/GeoIP.dat.gz http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz && gunzip -f /usr/lib/maxmind/GeoIP.dat.gz
	 wget -O /usr/lib/maxmind/GeoLiteCity.dat.gz http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz && gunzip -f /usr/lib/maxmind/GeoLiteCity.dat.gz
	wget -O /usr/lib/maxmind/GeoIPASNum.dat.gz http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz && gunzip -f /usr/lib/maxmind/GeoIPASNum.dat.gz
