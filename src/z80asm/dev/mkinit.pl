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
# Copyright (C) Paulo Custodio, 2011-2013
#
# Parse a list of *.h files and search for init functions. 
# Generates init.c with a new main function that calls all init functions before calling the 
# user main().
# Generates init.h that re-defines main as user_main, to be included in the main module.and init.h.
# The initialization sequence is the same as the order the function are retrieved from the
# command line arguments.
#
# Syntax of parsed *.h files:
# extern void initXXXX();			--> generates a call to initXXXX() from main() before
#	 									user_main() starts
# extern void finiXXXX();			--> generates a call to atexit(finiXXXX) from main() before
#	 									user_main() starts
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/dev/Attic/mkinit.pl,v 1.1 2013-11-11 23:47:05 pauloscustodio Exp $

use Modern::Perl;
use Getopt::Std;
use File::Basename;
use File::Slurp;
use List::Uniq 'uniq';
use Data::Dump 'dump';

my @INIT;

our $opt_o;		# output file name
getopts('o:') && @ARGV
	or die "Usage: ",basename($0)," [-o output] file.h...\n";

parse();
#dump \@INIT;
output($opt_o // "init");

#------------------------------------------------------------------------------
# parse input files, search for init functions, push to @INIT
#------------------------------------------------------------------------------
sub parse {
	while (<>) {
		/ ^ \s* extern \s+ void \s+ ( (?:init|fini) \w+) \s* \( \s* (?:void)? \s* \) \s* ; /x
			and push @INIT, [$ARGV, $1];
	}
}

#------------------------------------------------------------------------------
# output init file
#------------------------------------------------------------------------------
sub output {
	my($file) = @_;
	
	write_file("$file.h", <<"END_H");
#pragma once
#define main init_main
END_H

	my $includes = 
		join("\n", 
			map {"#include \"$_\""} 
			uniq
			map {$_->[0]} @INIT);
	my $init = 
		join("\n", 
			map { /^init/ ? "\t$_();" : "\tatexit($_);"} 
			map {$_->[1]} @INIT);
	
	write_file("$file.c", <<"END_C");
$includes
#include <stdlib.h>

extern int init_main(int argc, char *argv[]);

static void init(void)
{
$init
}

int main(int argc, char *argv[])
{
	init();
    return init_main(argc, argv);
}
END_C
}

exit 0;

__END__
# $Log: mkinit.pl,v $
# Revision 1.1  2013-11-11 23:47:05  pauloscustodio
# Move source code generation tools to dev/Makefile, only called on request,
# and keep the generated files in z80asm directory, so that build does
# not require tools used for the code generation (ragel, perl).
# Remove code generation for structs - use CLASS macro instead.
#
