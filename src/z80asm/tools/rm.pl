#!/usr/bin/env perl
use strict;
use warnings;
use File::Path qw(remove_tree);

my $force = 0;
my $recursive = 0;

# Parse flags
while (@ARGV && $ARGV[0] =~ /^-/) {
    my $flag = shift @ARGV;
    $force = 1 if $flag =~ /f/;
    $recursive = 1 if $flag =~ /r/;
}

@ARGV or exit 0 if $force;  # rm -f with no files is OK

foreach my $path (@ARGV) {
    if (-d $path) {
        if ($recursive) {
            remove_tree($path, { error => \my $err });
            if (@$err && !$force) {
                die "rm: failed to remove directory '$path'\n";
            }
        } else {
            die "rm: '$path' is a directory (use -r)\n" unless $force;
        }
    } elsif (-e $path) {
        unlink($path) or die "rm: cannot remove '$path': $!\n";
    } else {
        die "rm: '$path' does not exist\n" unless $force;
    }
}
