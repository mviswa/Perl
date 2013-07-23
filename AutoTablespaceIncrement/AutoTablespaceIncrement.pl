#!/usr/bin/perl
use strict;
use warnings;


`db2 "connect to db-name"`;
my @tbsp= grep /\//,`db2 "select RTRIM(substr(A.TBSP_NAME,1,30)),A.TBSP_FREE_PAGES as FREE,B.CONTAINER_NAME as CON_PATH from SYSIBMADM.TBSP_UTILIZATION A ,SYSIBMADM.CONTAINER_UTILIZATION B where A.TBSP_ID=B.TBSP_ID and A.TBSP_AUTO_RESIZE_ENABLED=0 with UR"`;


open (MYFILE, '>tbsbexec.db2');
print MYFILE "connect to db-name;\n";
foreach (@tbsp){
chomp;
s/^\s*//;
s/\s*$//;
my ($col1,$col2,$col3)=split /\s+/,$_,3;
#my $pages=(10000-$col2);
        if ($col2 <= 4000){
                my $pages=(10000-$col2);
                print MYFILE "alter tablespace $col1 extend (file \'$col3\' $pages);\n";
        }
}
print MYFILE "connect reset;\n";
print MYFILE "terminate;";
close (MYFILE);
`db2 "connect reset"`;

`db2 -tvf tbsbexec.db2`;