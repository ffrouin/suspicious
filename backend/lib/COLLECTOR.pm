#!/usr/bin/perl -w
#
# Package: COLLECTOR.pm
# Object:  Used to build system cmd from collectors config file.
#
# Date:    Sun Feb 14 08:18:52 CET 2016
# Author:  freddy@linuxtribe.fr

use strict;
package COLLECTOR;

sub build_cmd {
  my $c = $_[0];

  my $cmd = '';
  unless(open(COLL,"<collectors/$c.conf")) {
    warn "unable to open collectors/$c.conf for reading !"
  } else {
    while (<COLL>) {
      next if (/^[;#]/);
      if (/^[\s\t]*cmd[\s\t]*=[\s\t]*([^\t\s]+)[\s\t]*;?$/) {
        $cmd .= $1;
      } elsif (/^[\s\t]*cmd-args[\s\t]*=[\s\t]*(.+);?$/) {
        $cmd .= " ".$1;
      }
    }
    close (COLL);
  }
  return($cmd);
}

1;
