#!/usr/bin/perl -w
#
# Script:  suspicious.pl
# Object:  Used to collect logs and format data for the frontend
#
# Date:    Sun Feb 14 08:18:52 CET 2016
# Author:  freddy@linuxtribe.fr

use lib 'lib/';
use COLLECTOR;

my $conf = 'backend.conf';
my $backendLog = 'logs/backend.log';
my $hist_dir = '../frontend/db';
my $csv_output = '../frontend/banned_ip.csv';

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
      logMsg('INFO','collector',COLLECTOR::build_cmd($coll)." $log logs/$tag.$proc.log");
      system(COLLECTOR::build_cmd($coll)." $log logs/$tag.$proc.log");
    } else {
      logMsg('INFO','collector',COLLECTOR::build_cmd($coll)." $host:$log logs/$tag.$proc.log");
      system(COLLECTOR::build_cmd($coll)." $host:$log logs/$tag.$proc.log");
    }
    logMsg('INFO','processor',"cat logs/$tag.$proc.log | processors/$proc.pl $tag $hist_dir >> $csv_output");
    system("cat logs/$tag.$proc.log | processors/$proc.pl $tag $hist_dir >> $csv_output");
    logMsg('INFO','clean    ',"unlink logs/$tag.$proc.log");
    unlink("logs/$tag.$proc.log");
  }
}
close(FD);
close(LOG);
