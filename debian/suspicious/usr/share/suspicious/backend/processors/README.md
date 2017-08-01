# Suspicious

IT Threats GeoDashboard

# Backend processors

Backend processors scripts have to format the data for the frontend. Actually
suspicious supports actually two processors : lighttpd & fail2ban.

## Launch requirements

Backend processors take two launch args :
* tag : this tag will be used as a threat target, a reference to real host
present in logs. This allow you to masquerade real host data in your reports.
* hist_dir : root directory of the timelined csv tree.

## Output

Backend processors send their formated data to the standard output. These
results will be added to the frontend/banned_ip.csv which is the report
displayed on first application load in end-user browser.

The output has to be a CSV file with no header, it will be added by the
suspicious.pl script as follow :

	system("echo \"host,ip,service,occurences,country,region,city,lat,lon,timelog\"> $csv_output");

Backend processors may respect the following field order to display data :

	host,ip,service,occurences,country,region,city,lat,lon,timelog

timelog is raw HTML data, use as value separator :

	<br/>

## Timelined csv tree

Backend processors, to enable threat timeline browsing, needs to keep up to
date a csv file tree working as the following :

	frontend/db/<year>/<month>/<day>/suspicious_<hour>h<min>.csv

There is one file per hour, each of these files contains threat activity
report over this time period.

CSV fields are the same as for main report on standard output :

	host,ip,service,occurences,country,region,city,lat,lon,timelog

## Backend processor template

In order to help the community to provide processors for other engines
like or not like fail2ban, you'll find the backend/processors/template.pl
script that have the skeleton to allow easy integration.

## Fail2ban processor

The fail2ban processor will parse your fail2ban logs and extract data from
it. There's no settings to update if you are using standard fail2ban log files.

## Lighttpd processor

This processor works with web log files. It has been tested with lighttpd but
may be updated easily for other web server as apache2 or nginx.

You may update this processor script in order to configure the excluded pattern
you don't want to report and maybe the HTTP code status you want to track.
You may want look for 4xx or 5xx return codes to follow suspicious web
activity :

	my @excludedPatterns = (
					'\\.xml$',
					'\\.txt$',
					'\\.php$',
					'feed',
					'wp-'
				);

	my @trackedStatusCodes = (
					'4\d{2}',
					'5\d{2}'
				);


