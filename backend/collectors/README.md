# Suspicious

IT Threats GeoDashboard

# Backend collectors

Collectors are used to help suspicious backend to build a system command
in order to collect logs.

## How does it works

By default suspicious.pl expect any system command to run as the
following in order to retrieve logs :

	cmd [cmd-args] node:src dst

If your command does not support this syntax, you may edit the
suspicious.pl script in order to add an elsif condition :

	if ($coll eq 'myCollectorName') {
		logMsg('INFO','collector',COLLECTOR::build_cmd($coll)." here build your stuff using $host,$coll,$proc,$tag,$log from backend.conf");
		system(COLLECTOR::build_cmd($coll)." here build your stuff using $host,$coll,$proc,$tag,$log from backend.conf");
	}

# local collector

For any local files, we won't have any "node" args as we don't want to
duplicate a local file, a link would be better, so it was required to have
a specific command build instructions for this :

	cmd [cmd-args] src dst

	ln -s src dst

That's why we found this in the suspicious.pl script :

	if ($coll eq 'local') {
		logMsg('INFO','collector',COLLECTOR::build_cmd($coll)." $log logs/$tag.$proc.log");
		system(COLLECTOR::build_cmd($coll)." $log logs/$tag.$proc.log");
	}

