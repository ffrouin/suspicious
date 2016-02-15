check:
	whereis gunzip wget geoiplookup grep perl

install:
	cp -r frontend $(SITE_PATH)/
	ln -s $(SITE_PATH)/frontend $(SITE_PATH)/htdocs
	cp -r backend $(SITE_PATH)/

maxmind:
	wget -O /usr/lib/maxmind/GeoLiteCity.dat.gz http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz && gunzip -f /usr/lib/maxmind/GeoLiteCity.dat.gz
