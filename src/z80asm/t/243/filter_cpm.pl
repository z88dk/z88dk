#!/usr/bin/env perl

use Modern::Perl;
use Path::Tiny;

@ARGV==2 or die "Usage: $0 file.out filtered.out\n";
my($in, $out) = @ARGV;

my $bin = path($in)->slurp_raw;
$bin =~ s/\x0d+\x0a/\x0a/g;
$bin =~ s/^\x0a\x41\x3e\x08\x20\x08\x08\x20\x08\x0a//;
path($out)->spew_raw($bin);
