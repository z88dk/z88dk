#!/usr/bin/perl

use strict;
use warnings;
use POSIX qw/strftime/;
use TAP::Harness;

printf "Report %s\n", strftime("%y%m%d-%H:%M", localtime);
my $harness = TAP::Harness->new( {
    verbosity => $ENV{VERBOSE},
    exec => sub {
        my ($harness, $file) = @_;
        return [ $file ];
    },
    merge => 1,
    color => 1,
});

$harness->runtests(@ARGV)->all_passed or exit 1;
