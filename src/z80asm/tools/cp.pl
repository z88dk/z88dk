#!/usr/bin/env perl
use strict;
use warnings;
use File::Copy qw(copy);

@ARGV == 2 or die "usage: cp SRC DST\n";

my ($src, $dst) = @ARGV;

copy($src, $dst)
    or die "cp: failed to copy '$src' to '$dst': $!\n";
