#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time-6*24*60*60);
$year += 1900;
$mon += 1;
$mday = '0'.$mday if ($mday<10);
$mon = '0'.$mon if ($mon<10);

opendir(DIR,"/home/DB_BKPS");
        my @files = grep (/$mday-$mon-$year/,readdir(DIR));
        print "@files\n";
                foreach my $file (@files){
                chomp($file);
                unlink ($files[0]);
                        }
closedir(DIR);
