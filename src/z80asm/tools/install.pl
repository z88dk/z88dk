#!/usr/bin/env perl
use strict;
use warnings;
use File::Copy qw(copy);
use File::Path qw(make_path);
use Fcntl ':mode';

my $mode = 0755;
my $preserve = 0;
my $makedirs = 0;

# Parse flags
while (@ARGV && $ARGV[0] =~ /^-/) {
    my $flag = shift @ARGV;
    $mode     = oct($1) if $flag =~ /^-m(\d+)/;
    $preserve = 1       if $flag =~ /p/;
    $makedirs = 1       if $flag =~ /d/;
}

if ($makedirs) {
    for my $dir (@ARGV) {
        make_path($dir, { error => \my $err });
        die "install: failed to create '$dir'\n" if @$err;
        chmod $mode, $dir or die "install: chmod failed on '$dir': $!\n";
    }
    exit 0;
}

@ARGV == 2 or die "usage: install [-mMODE] [-p] SRC DST\n";

my ($src, $dst) = @ARGV;

copy($src, $dst)
    or die "install: failed to copy '$src' to '$dst': $!\n";

chmod $mode, $dst
    or die "install: chmod failed on '$dst': $!\n";

if ($preserve) {
    my @st = stat($src);
    utime $st[8], $st[9], $dst
        or die "install: utime failed on '$dst': $!\n";
}
