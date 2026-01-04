#!/usr/bin/env perl
use strict;
use warnings;
use Time::HiRes qw(time);

@ARGV or die "usage: time.pl COMMAND [ARGS...]\n";

my $start = time;

system(@ARGV);
my $raw = $?;   # raw exit status

my $end = time;
my $real = $end - $start;

# Break into hours, minutes, seconds
my $hours   = int($real / 3600);
my $minutes = int(($real - $hours * 3600) / 60);
my $seconds = $real - $hours * 3600 - $minutes * 60;

printf "real %dh%02dm%.3fs\n", $hours, $minutes, $seconds;

# Portable exit code extraction
my $exit = ($raw >> 8) & 0xFF;
exit $exit;
