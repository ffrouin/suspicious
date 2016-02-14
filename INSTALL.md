# Suspicious

IT Threats GeoDashboard

## How to deploy Suspicious

### Architecture

#### Frontend

Suspicious may be deployed within a web instance :

/var/www/suspicious.yourdomain.com/frontend (htdocs)

/var/www/suspicious.yourdomain.com/frontend/index.html (d3js)

/var/www/suspicious.yourdomain.com/frontend/img (ui ressources)

/var/www/suspicious.yourdomain.com/frontend/js (ui ressources)

/var/www/suspicious.yourdomain.com/frontend/geo (ui ressources)

/var/www/suspicious.yourdomain.com/frontend/db (timeline csv db)

#### Backend

/var/www/suspicious.yourdomain.com/backend

/var/www/suspicious.yourdomain.com/backend/suspicious.pl (main script)

/var/www/suspicious.yourdomain.com/backend/backend.conf (main config)

/var/www/suspicious.yourdomain.com/backend/collectors (collectors config)

/var/www/suspicious.yourdomain.com/backend/processors (processors config)

/var/www/suspicious.yourdomain.com/backend/logs (backend working dir)

### Check your system binaries

Suspicious uses system cmd for internal processings. Just challenge your
system using our Makefile with "check" arg, it may report to you missing
commands :

make check

whereis wget

wget: /usr/bin/wget /usr/bin/X11/wget /usr/share/man/man1/wget.1.gz

whereis gunzip

gunzip: /bin/gunzip /usr/share/man/man1/gunzip.1.gz

whereis geoiplookup

geoiplookup: /usr/bin/geoiplookup /usr/bin/X11/geoiplookup /usr/share/man/man1/geoiplookup.1.gz

### Deploy MaxMind GeoIP

Just check your system has wget, gunzip commands installed or install them :

sudo apt-get install wget

sudo apt-get install gunzip

Our Makefile provides maxmind geoip deployment feature if you use "maxmind" as
arg. Libs will be deployed in /usr/lib/maxmind. If you change this path,
please update backend/collectors/geoiplookup.conf file in order suspicious
to use your path instead of /usr/lib/maxmind.

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

### Instanciate a web service with nginx, lighttpd

End users should not access the backend, this directory can't be a child directory
of your web root directory (htdocs). Backend and Frontend directory may be in the
same directory while Frontend directory will be root directory of your web instance.

#### Make a test to check frontend is correctly working

Our deployment release content data from our system that should display
an initial report if you access your frontend before you launch any backend
scripts.

### Configure the backend

You need to configure the backend/backend.conf file in order to list
all nodes and log files the backend needs to retrieve in order to format
the data for the frontend.

Configuration is very simple :

;node	collector	processor	tag		file

root@ns1	scp		fail2ban	ns1		/var/log/fail2ban.log.1

root@ns2	scp		fail2ban	ns2		/var/log/fail2ban.log.1

root@ns3	scp		fail2ban	ns3		/var/log/fail2ban.log.1

### Launch backend processing

This application has been built entirely using relative links. It means in
order the suspicious.pl script to work, you need to be in the backend
directory. So to call it from cron, use this kind of command :

cd /path/to/backend && ./suspicious.pl

The backend produces logs in backend/logs/backend.log while collector
and processing errors will be send to standard error stream (2).

### Access your reports

If you go back to the frontend directory you may see :

* the banned_ip.csv file has been updated and content all the data you
processed when you previously called the suspicious.pl script from
the backend.

* the frontend/db directory has been updated with sub directory trees
containing timelined suspicious csv files.

Go back to your web browser and you may see at last authentication reports
if your fail2ban service is configured to monitor the ssh service on the
different nodes.

## How to add fail2ban services to suspicious threat groups

There is a small peace of code you will have to maintain in the index.html
frontend file in order to associate fail2ban services to suspicious threat
groups.

The d.service var contain the fail2ban service name, you can use either :

d.service ==

or

d.service.include(string)

to make your check and then return the right threat group image :

return('img/service-threat.png')

Here is the native peace of code included in your index.html :

.attr("xlink:href", function(d) {
                     if (d.service.includes('recidive')||d.occurences>=10) { return('img/hacker-threat.png'); }
                     else if (d.service == 'ssh') { return('img/ssh-threat.png'); }
                     else if (d.service.includes('cgpro-sip')) { return('img/sip-threat.png'); }
                     else if (d.service.includes('cgpro-smtp')) { return('img/mail-threat.png'); }
                     else if (d.service.includes('-wp')) { return('img/wordpress-threat.png'); }
                     else { return('img/unknown-threat.png'); }
                   })

