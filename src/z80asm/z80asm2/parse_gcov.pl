#!/usr/bin/env perl

#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

# parse the output of gcov

use Modern::Perl;

my @coverage;
my %current;
while (<>) {
	if (/^\s*$/) {
	}
	elsif (/^File '(.*)'/) {
		$current{file} = $1;
	}
	elsif (/^Lines executed:(\d+\.\d+)% of (\d+)/) {
		$current{coverage} = sprintf("%6.2f", $1);
		$current{lines} = sprintf("%6d", $2);
	}
	elsif (/^Creating/) {
		push @coverage, {%current};
		%current = ();
	}
	elsif (/^No executable lines/) {
		%current = ();
	}
	elsif (/^Removing/) {
	}
	elsif (/^Lines executed/) {
		print
	}
	else {
		die "cannot parse: $_";
	}
}

@coverage = sort {$a->{coverage} cmp $b->{coverage}} @coverage;

say "Coverag\t Lines\tFile";
my $count = 0;
my $sum_coverage = 0;
my $sum_lines = 0;
for (@coverage) {
	next if $_->{file} =~ m{/include/};
	next if $_->{file} =~ /\.h$/;
	
	say join("\t", $_->{coverage}.'%', $_->{lines}, $_->{file});
	
	$count++;
	$sum_coverage += $_->{lines} * $_->{coverage} / 100;
	$sum_lines += $_->{lines};
}
if ($count) {
	say sprintf("%6.2f%%\t%6d\tTOTAL", $sum_coverage / $count, $sum_lines);
}
