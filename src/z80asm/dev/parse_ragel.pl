#!/usr/bin/perl

#     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
#   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
#                ZZZZZ      888           888  0000         0000
#              ZZZZZ        88888888888888888  0000         0000
#            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
#          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
#        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
#      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
#    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
#  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM
#
# Copyright (C) Paulo Custodio, 2011-2014
#
# Preprocess file.rl and generate file.h
# Needed to allow usage of #define macros and #include in ragel input files
# Converts special tokens <NL> to "\n", <CAT> to "\t"; <CAT> concatenates.
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/dev/Attic/parse_ragel.pl,v 1.1 2014-12-13 00:49:46 pauloscustodio Exp $

use strict;
use warnings;
use File::Basename;
use File::Copy;

my @TEMP;
@ARGV == 1 or die "Usage: ",basename($0)," INPUT.rl";
my $FILE = basename(shift, ".rl");

# make .c
copy("$FILE.rl", "$FILE.c") or die "read $FILE.rl failed: $!\n";
push @TEMP, "$FILE.c";

# preprocess to .rl2
my $cmd = "cc -E $FILE.c";
open(my $in, "$cmd |") or die "Input from '$cmd' failed: $!\n";
open(my $out, ">", "$FILE.rl2") or die "Output to $FILE.rl2 failed: $!\n";
push @TEMP, "$FILE.rl2";

while (<$in>) {
	s/^#.*//; 
	s/^\"\".*//; 
	s/\t+/ /g; 
	s/ *<CAT> *//g; 
	s/ *<NL> */\n/g; 
	s/ *<TAB> */\t/g;
	print $out $_;
}
close($out) or die;
close($in) or die "'$cmd' failed: $!\n";

# ragel to .h2
$cmd = "ragel -G2 -o$FILE.h2 $FILE.rl2";
system($cmd) and die "'$cmd' failed: $!\n";
push @TEMP, "$FILE.h2";

# remove #line to .h
open($in, "<", "$FILE.h2") or die "Input from $FILE.h2 failed: $!\n";
open($out, ">", "$FILE.h") or die "Output to $FILE.h failed: $!\n";
while (<$in>) {
	s/^#.*//; 
	print $out $_;
}
close($out) or die;
close($in) or die;

unlink(@TEMP);
