#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year += 1900;
$mon += 1;
$mday = '0'.$mday if ($mday<10);
$mon = '0'.$mon if ($mon<10);


my $backup_folder = '/home/DB_BKPS';
chdir($backup_folder) or die "Cannot chdir to $backup_folder : $!";
my $date_folder = "$mday-$mon-$year";
#mkdir($backup_folder.'/'.$date_folder) or die("Cannot create $backup_folder.'/'.$date_folder : $!");
mkdir($date_folder) or die("Cannot create $date_folder : $!");

my $config_file = "dbbackup.config";
my @databases = removeComments(getFileContents($config_file));

foreach my $database (@databases){
        chomp($database);
        `mysqldump -u root -proot $database > $backup_folder/$date_folder/$database.sql`;
                }
`tar -cvzf $date_folder.tar.gz $date_folder`;
`rm -rf $date_folder`;

retention();

sub retentionpolicy{
        my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time-6*24*60*60);
$year += 1900;
$mon += 1;
$mday = '0'.$mday if ($mday<10);
$mon = '0'.$mon if ($mon<10);
my $date_folder = "$mday-$mon-$year";
        if (-e $date_folder){
                        unlink $date_folder or die ("Cannot Delete $date_folder : $!");
                        }
                }

sub getFileContents {
        my $file = shift ;
        open(FILE,$file) or die("Cannot open $file : $!");
        my @lines=<FILE>;
        close(FILE);
        return @lines;
                }
sub removeComments {
        my @lines = @_;
        my @cleaned = grep(!/^\s*#/,@lines);
        @cleaned = grep(!/^\s*$/,@cleaned);
        return @cleaned;
                }

	