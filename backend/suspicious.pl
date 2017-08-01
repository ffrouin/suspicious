#!/usr/bin/perl -w
#
# Script:  suspicious.pl
# Object:  Used to collect logs and format data for the frontend
#
# Date:    Sun Feb 14 08:18:52 CET 2016
# Author:  freddy@linuxtribe.fr

use lib '/usr/share/suspicious/backend/lib';
use COLLECTOR;

my $conf = '/etc/suspicious/backend.conf';
my $backendLog = '/var/log/suspicious.log';
my $hist_dir = '/var/lib/suspicious/db';
my $csv_output = '/var/www/html/suspicious/banned_ip.csv';

unless(open(LOG,">>$backendLog")) {
  die "Unable to open $backendLog for writing !";
}

sub logMsg {
  my ($class,$module,$msg) = @_;

  my $time = localtime(time);
  print LOG "$time	$class	[$module]	$msg\n";
}

unless(open(FD,"<$conf")) {
  logMsg('ERROR','main',"unable to open $conf for reading !");
  exit 1;
}
system("echo \"host,ip,service,occurences,country,region,city,lat,lon,timelog\"> $csv_output");

my ($host,$coll,$proc,$tag,$log);
while(<FD>) {
  next if (/^[;#]/);
  if (/^([^\t\s]+)[\t\s]+([^\t\s]+)[\t\s]+([^\t\s]+)[\t\s]+([^\t\s]+)[\t\s]+([^\t\s]+)[\t\s]*$/) {
    ($host,$coll,$proc,$tag,$log) = ($1,$2,$3,$4,$5);
    if ($coll eq 'local') {
      logMsg('INFO','collector',COLLECTOR::build_cmd($coll)." $log /var/lib/suspicious/data/$tag.$proc.log");
      system(COLLECTOR::build_cmd($coll)." $log /var/lib/suspicious/data/$tag.$proc.log");
    } else {
      logMsg('INFO','collector',COLLECTOR::build_cmd($coll)." $host:$log /var/lib/suspicious/data/$tag.$proc.log");
      system(COLLECTOR::build_cmd($coll)." $host:$log /var/lib/suspicious/data/$tag.$proc.log");
    }
    logMsg('INFO','processor',"cat /var/lib/suspicious/data/$tag.$proc.log | /usr/share/suspicious/processors/$proc.pl $tag $hist_dir >> $csv_output");
    system("cat /var/lib/suspicious/data/$tag.$proc.log | /usr/share/suspicious/backend/processors/$proc.pl $tag $hist_dir >> $csv_output");
    logMsg('INFO','clean    ',"unlink /var/lib/suspicious/data/$tag.$proc.log");
    unlink("/var/lib/suspicious/data/$tag.$proc.log");
  }
}
close(FD);
close(LOG);
