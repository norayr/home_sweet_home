#!/usr/bin/perl

use List::MoreUtils qw/uniq/;

if ($ARGV[0]){
     $appname = $ARGV[0];
}else{
     print "perl unblock.pl appname\n";
    exit 0;
}

$overfor = 0;
$overfor_mark = 1;
@install_file = " ";

for ( $i=0; $i <= 5; $i++) {

      @results = readpipe("emerge -pv $appname --verbose-conflicts  >emerge_block.txt 2>&1");

            open(DUP, "emerge_block.txt");
                 @lms=<DUP>;
            close (DUP);

      $overfor = 1;
      foreach $lms(@lms){
              if ($lms =~ /Multiple package instances/){
                        $overfor = 0;
              }
              elsif  ($lms =~ /\ \((\S{1,20})\/(\S{2,40})-\d{1,2}\./){
                                 $temp1 = $1;
                                 $temp2 = $2;
                                 $noperl = "$temp1/$temp2";
                                 print "$temp1/$temp2\n";
                                 push(@install_file,$noperl);
              }
              elsif ($ms =~ /there are no ebuilds to satisfy \"(\S{2,40})\"/){
                          print "\n$1\n";
                         $overfor = 1;
                          last;
              }else{
             }
      }
      if ($overfor eq $overfor_mark){
            last;
      }
     @uniq_install_file = uniq@install_file;               
      foreach $temp3(@uniq_install_file){
               $appname = "$appname $temp3";
      }
}

print "======Run emerge with -->\n";
@uniq_install_file = uniq@install_file;               
foreach $hd(@uniq_install_file){
                 print "$hd ";
}
print "\n";
