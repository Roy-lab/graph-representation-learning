#!/usr/bin/env perl
# usage: ./script.pl [table.txt] [row_size (e.g. 16)] [col_size (e.g. 20)] ["on"/"off" (optional for marking values or not)]
# table.txt should have row and column header lines
use strict;
use warnings;
#my $row_size = 16;
#my $col_size = 20;
my $row_size = $ARGV[1];
my $col_size = $ARGV[2]; chomp $col_size;
my $marking = "off";
if (exists $ARGV[3]) {
	$marking = $ARGV[3];
}

my @cols = ();
my @rows = ();
my %data = ();
open (TAB, $ARGV[0]) or die;
while (<TAB>) {
	my $line = $_; chomp $line;
	my @line = split /\t/, $line;
	if (scalar @cols == 0) {
		shift @line;
		@cols = @line;
	} else {
		my $rowterm = shift @line;
		push @rows, $rowterm;
		for (my$i=0; $i<scalar @cols; $i++) {
			my $colterm = $cols[$i];
			#my $val = sprintf "%.1f", $line[$i];
			my $val = $line[$i];
			$data{$rowterm}{$colterm} = $val;
		}
	}
}
close TAB;

#my $flag = 0;
##my $spacer = 1;
foreach my$rowterm (@rows) {
	my $rowp = $rowterm."||".$row_size;

	foreach my$colterm (@cols) {
		my $colp = $colterm."||".$col_size;
		my $valp = "0|1|";
		if ($data{$rowterm}{$colterm} > 0) {
			my $val = sprintf "%.1f", $data{$rowterm}{$colterm};
			if ($marking eq "off") {
				$valp = $val."|1|";	# without number, default
			} elsif ($marking eq "on") {
				$valp = $val."|1|".$val;# with number
			}
		}
		print "$rowp\t$colp\t$valp\n";
	}
	#if ($flag==0) {print "|-\t|Spacer|6|VSpacer$spacer\n"; $flag++; $spacer++;}
}

exit
			
