#!/usr/bin/env perl

use Modern::Perl;
use Path::Tiny;
use Test::More;

@ARGV==2 or die "Usage: $0 file string\n";
my($file, $string) = @ARGV;
my $got = path($file)->slurp_raw;
is $got, $string, "Got $got";
done_testing;
