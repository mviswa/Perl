#!/usr/bin/perl
use strict();
use warnings();
use diagnostics();

$dbname = "awdrt";
#$schem = "KSRTC";

`db2 "connect to $dbname"`;
#my @func =  grep (/\d+-\d+-/ , `db2 "select substr(FUNCNAME,1,40) as FUNCNAME , substr(BNAME,1,20) AS PACKNAME , substr(FUNCSCHEMA,1,20) as SCHEMA ,CREATE_TIME FROM SYSCAT.FUNCTIONS  , SYSCAT.ROUTINEDEP   WHERE SYSCAT.FUNCTIONS.SPECIFICNAME = SYSCAT.ROUTINEDEP.ROUTINENAME AND SYSCAT.FUNCTIONS.FUNCNAME IN (  select FUNCNAME from SYSCAT.FUNCTIONS where create_time > current timestamp -1 day order by create_time)"`);

my @func =  grep (/\d+-\d+-/ , `db2 "SELECT SUBSTR(A.FUNCNAME,1,40) AS FUNCNAME , SUBSTR(B.BNAME,1,20) AS PACKNAME , SUBSTR(A.FUNCSCHEMA,1,20) AS SCHEMA ,A.CREATE_TIME FROM SYSCAT.FUNCTIONS A , SYSCAT.ROUTINEDEP B  WHERE A.SPECIFICNAME = B.ROUTINENAME AND A.CREATE_TIME > CURRENT TIMESTAMP -1 day ORDER BY CREATE_TIME"`);


	if (@func){
		foreach my $funname (@func){
			chomp($funname);
			$funname =~ s/^\s*//;
			$funcnme =~ s/\s*$//;
			my ($fname,$fbname,$fschema,$ftime) = split (/\s+/ , $funname , 4);
			print "$fname compiled under schema $fschema at $ftime\n"
			}
		}
	else{
	print "No Functions Deployed \n\n";
	print "-----------------------------------------------------------------------\n\n";
	}

#print "Functions Deployed\n ";
#print "------------------------------------------------------------------------------\n";
#print "@func\n";

#my @procs = grep (/\d+-\d+-/ , ` db2 "SELECT SUBSTR(PROCNAME,1,40) AS PROCNAME , substr(BNAME,1,20) AS PACKNAME , substr(PROCSCHEMA,1,20) as SCHEMA ,CREATE_TIME FROM SYSCAT.PROCEDURES  , SYSCAT.ROUTINEDEP   WHERE SYSCAT.PROCEDURES.SPECIFICNAME = SYSCAT.ROUTINEDEP.ROUTINENAME AND SYSCAT.PROCEDURES.PROCNAME IN (  select procname from syscat.procedures where create_time > current timestamp -1 day order by create_time)"`);

my @procs = grep (/\d+-\d+-/ , `db2 "SELECT SUBSTR(A.PROCNAME,1,40) AS PROCNAME , substr(B.BNAME,1,20) AS PACKNAME , substr(A.PROCSCHEMA,1,20) as SCHEMA ,A.CREATE_TIME FROM SYSCAT.PROCEDURES A , SYSCAT.ROUTINEDEP B  WHERE A.SPECIFICNAME = B.ROUTINENAME AND A.CREATE_TIME > CURRENT TIMESTAMP -1 day ORDER BY CREATE_TIME"`);


#print "Procedures Deployed\n";
#print "------------------------------------------------------------------------------";
#print "@procs\n\n";
        if (@procs){
		print "List of Procedure(s) deployed\n\ ";
		print "------------------------------------------------------------------------\n";
 foreach my $procname (@procs){
                chomp($procname);
                $procname =~ s/^\s*//;
                $procname =~ s/\s*$//;
                my($name,$bname,$schema,$time) = split (/\s+/ ,$procname,4);
		print "$name compiled under schema $schema at $time\n\n";
		print "-------------------------------------------------------------------------\n";
                #print MYFILE "db2exfmt -d awdrt -e db2inst1 -g -l -n '$bname' -s ksrtc -o orig_plan.out -w -1 -# 0 -v % > $name-$time.exfmt\n";
		print "Estimated Cost per section for $name\n";
		print "-------------------------------------------------------------------------\n";
		my @cost = `db2expln -d $dbname -c $schema -p $bname -s 0 -t | grep "Estimated Cost"|sort -k4 -r`;
		print "@cost\n";
	#	open (MYFILE , '</home/DB_BKPS/$name-$time.expln')
	#		or die "Cannot open file : $!";
	#				while (my $match=<MYFILE>) {
	#			if ($line =~ /Estimated\sCost/){
	#				print "$match\n";
	#				}
	#			}
                }

                }
        else {

        print "No Procedure(s) Compiled\n";
	print "--------------------------------------------------------------------------------\n";
                }
`db2 "connect reset"`;
`db2 "terminate"`;
