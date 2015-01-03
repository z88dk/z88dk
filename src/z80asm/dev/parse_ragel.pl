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
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/dev/Attic/parse_ragel.pl,v 1.4 2015-01-03 18:39:06 pauloscustodio Exp $

use strict;
use warnings;
use File::Basename;
use File::Copy;
use File::Slurp;

my $RAGEL = "ragel -G2";

my @TEMP;
@ARGV == 1 or die "Usage: ",basename($0)," INPUT.rl";
my $FILE = basename(shift, ".rl");

# parse loops to .rl -> .rl1
preprocess("$FILE.rl", "$FILE.rl1");
push @TEMP, "$FILE.rl1";

# make .rl1 -> .c
copy("$FILE.rl1", "$FILE.c") or die "read $FILE.rl failed: $!\n";
push @TEMP, "$FILE.c";

# preprocess to .c -> .rl2
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

# ragel to .rl2 -> .h2
$cmd = "$RAGEL -o$FILE.h2 $FILE.rl2";
system($cmd) and die "'$cmd' failed: $!\n";
push @TEMP, "$FILE.h2";

# remove #line .h2 -> .h
open($in, "<", "$FILE.h2") or die "Input from $FILE.h2 failed: $!\n";
open($out, ">", "$FILE.h") or die "Output to $FILE.h failed: $!\n";
while (<$in>) {
	s/^#.*//; 
	next unless /\S/;
	print $out $_;
}
close($out) or die;
close($in) or die;

unlink(@TEMP);
exit 0;

#-----------------------------------------------------------------------
# Preprocess input file, expanding loops:
#	#foreach VAR in A1, A2, \
#					A3, A4
#		... VAR ... 			-> exchanged for An
#	#endfor VAR
#	... #LCASE(Text) ...		-> replace by TEXT
#	... #UCASE(Text) ...		-> replace by text
#	... #SUBST(text,aa,bb) ...	-> replace aa by bb in text
#-----------------------------------------------------------------------
sub preprocess {
	my($in_file, $out_file) = @_;

	my $text = read_file($in_file);
	$text = expand_foreach($text);
	$text = expand_func($text, "SUBST", 3, 
				sub {  	my($in, $from, $to) = @_;
						$in =~ s/$from/$to/g;
						return $in;
				});
	$text = expand_func($text, "LCASE", 1, 
				sub {  	my($in) = @_;
						return lc($in);
				});
	$text = expand_func($text, "UCASE", 1, 
				sub {  	my($in) = @_;
						return uc($in);
				});
	write_file($out_file, $text);
}

sub expand_foreach {
	my($text) = @_;
	$text =~ s/^ [ \t]* \#foreach [ \t]+ (\S+) [ \t]+ in [ \t]+
							( (?: \\ \n | [^\n] )+ ) \n
				 ( .*? )
			   ^ [ \t]* \#endfor [ \t]+ \1 [ \t]* \n
			  / expand_one_foreach($1, $2, $3) /xgems;
	return $text;
}

sub expand_one_foreach {
	my($var, $series, $text) = @_;
	$series =~ s/\\\n/ /g;
	my $ret = "";
	my @series = split(/,/, $series);
	for my $value (@series) {
		$value =~ s/^\s+//; 
		$value =~ s/\s+$//; 
		my $instance = $text;
		$instance =~ s/$var/$value/g;
		$instance = expand_foreach($instance);
		$ret .= $instance;
	}
	return $ret;
}

sub expand_func {
	my($text, $name, $num_args, $func) = @_;
	$text =~ s/\# $name \( ( .*? ) \)
	          / expand_one_func($name, $num_args, $func, $1) /xgem;
	return $text;
}

sub expand_one_func {
	my($name, $num_args, $func, $in) = @_;
	for ($in) {
		s/^\s+//;
		s/\s+$//;
	}
	my @args = split(/,/, $in);
	@args == $num_args 
		or die "#name expects $num_args arguments, got ",
			   scalar(@args), "\n";
	for (@args) {
		s/^\s+//;
		s/\s+$//;
	}
	
	return $func->(@args);
}
