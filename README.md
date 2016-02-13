# Suspicious

IT Threats GeoDashboard

Demo : http://awstats.linuxtribe.fr/suspicious/

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

# Author

Freddy Frouin

http://freddy.linuxtribe.fr
