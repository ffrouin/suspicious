# Suspicious

IT Threats GeoDashboard

# Backend processors

Backend processors scripts have to format the data for the frontend. Actually
suspicious support only a fail2ban processor script.

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

timelog is raw HTML data with <br/> as value separator.

## Timelined csv tree

Backend processors, to enable threat timeline browsing, needs to keep up to
date a csv file tree working as the following :

frontend/db/<year>/<month>/<day>/suspicious_<hour>h<min>.csv

There is one file per hour, each of these files contains threat activity
report over this time period.

CSV fields are the same as for main report on standard output :

	host,ip,service,occurences,country,region,city,lat,lon,timelog
