#!/usr/bin/perl

# Z88-DK Z80ASM - Z80 Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Preprocess file.rl and generate file.h
# Needed to allow usage of #define macros and #include in ragel input files
# Converts special tokens <NL> to "\n", <TAB> to "\t"; <CAT> concatenates.
# Expands <MAP>(aa=>AA,bb=>BB,) .. using <A> and <B>

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
my $cmd = "gcc -E $FILE.c";
open(my $in, "$cmd |") or die "Input from '$cmd' failed: $!\n";
open(my $out, ">", "$FILE.rl2") or die "Output to $FILE.rl2 failed: $!\n";
push @TEMP, "$FILE.rl2";

while (<$in>) {
	s/^#.*//; 
	s/<MAP>(.*)/expand_map($1)/ge;
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

# convert to UNIX LF
$cmd = "dos2unix $FILE.h";
system($cmd) and die "'$cmd' failed: $!\n";

unlink(@TEMP);
exit 0;

#-----------------------------------------------------------------------
# Expand <MAP>
#-----------------------------------------------------------------------
sub expand_map {
	my($text) = @_;
	my @args;
	my $ret = "";
	
	my $expr = qr/(?: "[^"]*" | '[^']*' | [^\),] )*/x;
	
	for ($text) {
		/^\s*\(/gc or die "missing '(' after <MAP>";
		my $found_end;
		while (/\G\s*($expr)\s*([,\)])/gc) {
			my $arg = $1;
			my $end = $2;
			if ($arg ne "") {
				my @arg = split(/\s*=>\s*/, $arg);
				push @args, \@arg;
			}
			if ($end eq ")") {
				$found_end = 1;
				last;
			}
		}
		$found_end or die "missing ')' after <MAP>";
		/\G\s*(.*)/gc;
		my $macro = $1."\n";
		
		# expand macro for each @args
		for (@args) {
			my @values = @$_;
			my $instance = $macro;
			$instance =~ s/<([A-Z])>/ $values[ord($1)-ord('A')] || "" /ge;
			$ret .= $instance;
		}
	}
	return $ret;
}
		
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
