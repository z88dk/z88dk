#!/usr/bin/env perl
use strict;
use warnings;
use File::Path qw(make_path);

my $parents = 0;

# Parse flags
while (@ARGV && $ARGV[0] =~ /^-/) {
    my $flag = shift @ARGV;
    $parents = 1 if $flag =~ /p/;
}

@ARGV == 1 or die "usage: mkdir [-p] DIR\n";

my $dir = shift @ARGV;

if ($parents) {
    make_path($dir, { error => \my $err });
    if (@$err) {
        die "mkdir: failed to create '$dir'\n";
    }
} else {
    mkdir($dir) or die "mkdir: cannot create '$dir': $!\n";
}
