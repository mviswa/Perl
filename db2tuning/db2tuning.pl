#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;

use Data::Dumper;

`db2 "connect to sample"`;
my @dbmcfg = grep /=/,`db2 "get snapshot for dbm"`;
    my %dbmcfg;
    foreach my $tmpdbm (@dbmcfg) {
        chomp($tmpdbm);
        $tmpdbm =~ s/^\s*//;
        $tmpdbm =~ s/\s*$//;
        my ($col3,$col4) = split /\s*=\s*/,$tmpdbm,2;
        $dbmcfg{$col3}=$col4;
    }
print Dumper(\%dbmcfg);

