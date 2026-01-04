#!/usr/bin/env perl
use strict;
use warnings;
use File::Copy qw(move copy);

@ARGV == 2 or die "usage: mv SRC DST\n";

my ($src, $dst) = @ARGV;

# Try atomic rename first
if (!move($src, $dst)) {
    # Fallback: copy + delete
    copy($src, $dst)
        or die "mv: failed to copy '$src' to '$dst': $!\n";
    unlink($src)
        or die "mv: failed to remove '$src': $!\n";
}
