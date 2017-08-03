# Suspicious

IT Threats GeoDashboard

## Architecture

/var/www/suspicious.yourdomain.com/backend

/var/www/suspicious.yourdomain.com/backend/suspicious.pl (main script)

/var/www/suspicious.yourdomain.com/backend/backend.conf (main config)

/var/www/suspicious.yourdomain.com/backend/collectors (collectors config)

/var/www/suspicious.yourdomain.com/backend/processors (processors scripts)

/var/www/suspicious.yourdomain.com/backend/logs (backend working dir)

### Configure the backend

You need to configure the backend/backend.conf file in order to list
all nodes and log files the backend needs to retrieve in order to format
the data for the frontend.

Configuration is very simple :

	;node		collector	processor	tag		file
	adm@ns1		scp		fail2ban	ns1		/var/log/fail2ban.log.1
	adm@ns2		scp		fail2ban	ns2		/var/log/fail2ban.log.1
	adm@ns3		scp		fail2ban	ns3		/var/log/fail2ban.log.1

### Launch backend processing

The backend/suspicious.pl script will launch all processings to collect and format your data
for the suspicious frontend. It will parse the backend/backend.conf file and will call defined
collectors and processors.

This application has been built entirely using relative links. It means in
order to launch properly the suspicious.pl script, you need to be in the backend
directory. So to call it from cron, use this kind of call :

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
if your fail2ban service is configured to monitor the ssh service on your
different nodes.

