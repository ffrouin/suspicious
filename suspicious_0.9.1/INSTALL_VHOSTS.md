# Suspicious

IT Threats GeoDashboard

## How to deploy multiple instances of Suspicious on different virtual hosts

We assume you did deploy suspicious debian package to install the application on your server.

### Everything on the same system

End users should not access the backend, this directory won't be a child directory
of your web root directory (htdocs). Backend and Frontend directory may stand in the
same directory while Frontend directory will be the root directory of your web instance.

### Frontend/Backend Architecture

It would be possible to define an architecture with a frontend and a backend server :
  * if data duplication is not an issue for you, a simple RDIST (differential file sync
over ssh) would allow you to plan frontend update,
  * an NFS mount query from the backend server should allow to mount the frontend/db
directory with read/write access to enable backend processors to update the frontend.

## Make a test to check frontend is correctly working

Our deployment release content data from our system that should display
an initial report if you access your frontend before you launch any backend
script.

## Configure the backend

We assume deployed a copy of /usr/share/suscipious/frontend and 
/usr/share/suspicious/backend and you've updated several vars in suspicious.pl
script :

	use lib 'path/to/lib/';
	use COLLECTOR;

	my $conf = 'path/to/backend.conf';
	my $backendLog = 'path/to/logs/backend.log';
	my $hist_dir = 'path/to/db';
	my $csv_output = 'path/to/banned_ip.csv';

You need to configure the backend/backend.conf file in order to list
all nodes and log files the backend needs to retrieve in order to format
the data for the frontend.

Configuration is very simple :

	;node		collector	processor	tag		file
	adm@ns1		scp		fail2ban	ns1		/var/log/fail2ban.log.1
	adm@ns2		scp		fail2ban	ns2		/var/log/fail2ban.log.1
	adm@ns3		scp		fail2ban	ns3		/var/log/fail2ban.log.1

## Launch backend processing

The backend/suspicious.pl script will launch all processings to collect and format your data
for the suspicious frontend. It will parse the backend/backend.conf file and will call defined
collectors and processors.

This application has been built entirely using relative links. It means in
order to launch properly the suspicious.pl script, you need to be in the backend
directory. So to call it from cron, use this kind of call :

	cd /path/to/backend && ./suspicious.pl

The backend produces logs in backend/logs/backend.log while collector
and processing errors will be send to standard error stream (2).

## Access your reports

If you go back to the frontend directory you may see :

  * the banned_ip.csv file has been updated and content all the data you
processed when you previously called the suspicious.pl script from
the backend.

  * the frontend/db directory has been updated with sub directory trees
containing timelined suspicious csv files.

Go back to your web browser and you may see at last authentication reports
if your fail2ban service is configured to monitor the ssh service on your
different nodes.

## How to add fail2ban services to suspicious threat groups

There is a small peace of code you will have to maintain in the index.html
frontend file in order to associate fail2ban services to suspicious threat
groups : mail, telephony, email, web, recidive.

### Threat groups

If you need to modify or adapt groups icons, groups name, update the
following var in frontend/index.html :

	var legendMap = [ { 'img/ssh-threat.png' : 'Authentication' },
			  { 'img/sip-threat.png' : 'Telephony' },
			  { 'img/mail-threat.png' : 'Email' },
			  { 'img/wordpress-threat.png' : 'Web' },
			  { 'img/hacker-threat.png' : 'Recidive' },
			  { 'img/unknown-threat.png' : 'Uncommented' }
			];

### Threat loading from csv files

Then, when suspicious will load threat from csv files, we'll have to check
fail2ban service name (d.service) and return the right image to this threat.

The d.service var contain the fail2ban service name, you can use either :

	d.service == "<string>"

or

	d.service.include("<string>")

to make your check and then return the right threat group image to end-user UI :

	return('img/service-threat.png')

Here is the native peace of code included in your index.html you'll have to update :

	.attr("xlink:href", function(d) {
                     if (d.service.includes('recidive')||d.occurences>=10) { return('img/hacker-threat.png'); }
                     else if (d.service == 'ssh') { return('img/ssh-threat.png'); }
                     else if (d.service.includes('cgpro-sip')) { return('img/sip-threat.png'); }
                     else if (d.service.includes('cgpro-smtp')) { return('img/mail-threat.png'); }
                     else if (d.service.includes('-wp')) { return('img/wordpress-threat.png'); }
                     else { return('img/unknown-threat.png'); }
                   })

