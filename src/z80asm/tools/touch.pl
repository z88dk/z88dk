#!/usr/bin/env perl
use strict;
use warnings;
use Time::HiRes qw(time);

@ARGV == 1 or die "usage: touch FILE\n";

my $file = shift;

# Create file if missing
if (!-e $file) {
    open my $fh, '>', $file or die "touch: cannot create '$file': $!\n";
    close $fh;
}

# Update mtime
my $now = time;
utime $now, $now, $file
    or die "touch: cannot update timestamp on '$file': $!\n";
