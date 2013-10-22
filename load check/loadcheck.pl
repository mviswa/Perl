#!/usr/bin/perl

use strict;
use warnings ;
use diagnostics ;

my $uptime = `uptime`;

my ($tmp1,$tmp2)=split (/load average:/, $uptime,2);
my ($load,$load1,$load2)=split (/,/,$tmp2,3);
#$load =~ s/\s*$//;
$load =~ s/^\s*//;
print "$load\n";