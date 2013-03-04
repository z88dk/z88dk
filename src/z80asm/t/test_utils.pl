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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/test_utils.pl,v 1.28 2013-03-04 23:23:37 pauloscustodio Exp $
# $Log: test_utils.pl,v $
# Revision 1.28  2013-03-04 23:23:37  pauloscustodio
# Removed writeline, that was used to cancel listing of multi-line
# constructs, as only the first line was shown on the list file. Fixed
# the problem in DEFVARS and DEFGROUP. Side-effect: LSTOFF line is listed.
#
# Revision 1.27  2013/02/27 22:32:38  pauloscustodio
# Abort test at t_compile_module() if compilation failed
#
# Revision 1.26  2013/02/25 21:37:30  pauloscustodio
# Show output difference of t_run_module() in visual-diff, to allow easy merge of changes
#
# Revision 1.25  2013/02/22 17:26:34  pauloscustodio
# Decouple assembler from listfile handling
#
# Revision 1.24  2013/02/19 22:52:40  pauloscustodio
# BUG_0030 : List bytes patching overwrites header
# BUG_0031 : List file garbled with input lines with 255 chars
# New listfile.c with all the listing related code
#
# Revision 1.23  2013/02/12 00:55:00  pauloscustodio
# CH_0017 : Align with spaces, deprecate -t option
#
# Revision 1.22  2013/02/11 21:54:38  pauloscustodio
# BUG_0026 : Incorrect paging in symbol list
#
# Revision 1.21  2013/01/20 13:18:10  pauloscustodio
# BUG_0024 : (ix+128) should show warning message
# Signed integer range was wrongly checked to -128..255 instead
# of -128..127
#
# Revision 1.20  2013/01/14 00:22:31  pauloscustodio
# Allow t_z80asm_ok() with warnings
#
# Revision 1.19  2012/06/07 10:17:57  pauloscustodio
# delay after deleting files before calling new z80asm
#
# Revision 1.18  2012/05/29 21:02:19  pauloscustodio
# Changes for linux:
# - call ./z80asm instead of z80asm
# - memory addresses appear as 0x0xHHHH in Linux (one 0x by user, one by %p)
#
# Revision 1.17  2012/05/26 18:50:26  pauloscustodio
# Use .o instead of .c to build test program, faster compilation.
# Use gcc to compile instead of cc.
#
# Revision 1.16  2012/05/24 10:58:39  pauloscustodio
# BUG_0018 : stack overflow in '@' includes - wrong range check
#
# Revision 1.15  2012/05/23 19:57:59  pauloscustodio
# Test that files created with -c have correct content
#
# Revision 1.14  2012/05/22 20:33:34  pauloscustodio
# Added tests
#
# Revision 1.13  2012/05/20 05:51:19  pauloscustodio
# Need more test files, mask error return after exception
#
# Revision 1.12  2012/05/20 05:40:00  pauloscustodio
# test asm only delete main test files before attempting to assemble, create other test files for multipl-object assembly
#
# Revision 1.11  2012/05/17 15:03:37  pauloscustodio
# Add functions to white-box test C modules by compiling and running a test C main() function
#
# Revision 1.10  2012/05/11 19:41:26  pauloscustodio
# white space
#
# Revision 1.9  2012/04/22 20:34:13  pauloscustodio
# tab width
#
# Revision 1.8	2011/10/07 17:29:10  pauloscustodio
# Add test functions for lib file format
#
# Revision 1.7	2011/08/18 21:49:44  pauloscustodio
# add objfile() to generate expected object file format
#
# Revision 1.6	2011/08/14 19:49:05  pauloscustodio
# - Added test case to verify that incomplete files are deleted on error
#
# Revision 1.5	2011/07/14 01:32:09  pauloscustodio
#	  - Unified "Integer out of range" and "Out of range" errors; they are the same error.
#	  - Unified ReportIOError as ReportError(ERR_FILE_OPEN)
#	  CH_0003 : Error messages should be more informative
#		  - Added printf-args to error messages, added "Error:" prefix.
#	  BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
#		  - Raise ERR_UNBALANCED_PAREN instead
#
# Revision 1.4	2011/07/11 16:23:44  pauloscustodio
# Factor capture code in t_z80asm_capture() in test_utils.pl
#
# Revision 1.3	2011/07/09 18:25:35  pauloscustodio
# Log keyword in checkin comment was expanded inside Log expansion... recursive
# Added Z80asm banner to all source files
#
# Revision 1.2	2011/07/09 17:36:09  pauloscustodio
# Copied cvs log into Log history
#
# Revision 1.1	2011/07/09 01:02:45  pauloscustodio
# Started to build test suite in t/ *.t unsing Perl prove. Included test for all standard
# Z80 opcodes; need to be extended with directives and opcodes for Z80 variants.
#
# Common utils for tests

use Modern::Perl;
use File::Slurp;
use Capture::Tiny::Extended 'capture';
use Test::Differences; 
use List::AllUtils 'uniq';

my $STOP_ON_ERR = grep {/-stop/} @ARGV; 
my $KEEP_FILES	= grep {/-keep/} @ARGV; 
my $test	 = "test";

sub z80asm	 { $ENV{Z80ASM} || "./z80asm" }

my @TEST_EXT = (qw( asm lst inc bin bn0 bn1 bn2 bn3 map obj lib sym def err 
					exe c o asmlst ));
my @MAIN_TEST_FILES;
my @TEST_FILES;
my @IDS = ("", 0 .. 20);
my %FILE;

for my $ext (@TEST_EXT) {
	for my $id (@IDS) {
		my $file = $FILE{$ext}{$id} = $test.$id.".".$ext;
		my $sub_name = $ext.$id."_file";
		no strict 'refs';
		*$sub_name = sub { return $file };
		
		push @MAIN_TEST_FILES, $file if $id eq "";
		push @TEST_FILES, $file;
	}
}

#------------------------------------------------------------------------------
sub _unlink_files {
	my($line, @files) = @_;
	@files = grep {-f} uniq(@files);
	is unlink(@files), scalar(@files), "$line unlink @files";
	while (grep {-f} @files) { sleep 1 };	# z80asm sometimes cannot create errfile
}

#------------------------------------------------------------------------------
sub unlink_testfiles {
	my(@additional_files) = @_;
	my $line = "[line ".((caller)[2])."]";
	if ($KEEP_FILES) {
		diag "$line -keep : kept test files";
	}
	else {
		_unlink_files($line, @TEST_FILES, @additional_files);
	}
}

#------------------------------------------------------------------------------
# Args:
#	asm, asm1, asm2, ... : source text, asm is main file; can use " : " to split lines
#	org : -1 to skip -r0 option, >= 0 to define -r{org}, undef for -r0, org = decimal value
# 	options : additional assemble options
#   out : expected output, if any
#   err : expected errors, if any
#   bin : expected binary output if defined, undef if compilation should fail
# 	nolist : true to remove -l option

sub t_z80asm {
	my(%args) = @_;
	
	my $line = "[line ".((caller)[2])."]";
	
	_unlink_files($line, @TEST_FILES);
	
	# build input files
	my @asm; 
	my @obj;
	my @lst;
	my @sym;
	for my $id (@IDS) {
		my $asm = $args{"asm$id"} or next;
		$asm =~ s/\s+:\s+/\n/g;
		$asm .= "\n";
		
		write_file($FILE{asm}{$id}, $asm);
		push @asm, $FILE{asm}{$id};
		push @obj, $FILE{obj}{$id};
		push @lst, $FILE{lst}{$id};
		push @sym, $FILE{sym}{$id};
	}
	
	# assemble
	my $cmd = z80asm()." ";
	exists($args{nolist}) or
		$cmd .= "-l ";
	$cmd .= "-b ";
	
	# org
	if (! exists $args{org}) {
		$cmd .= "-r0 ";
	}
	elsif ($args{org} < 0) {
		# no -r
	}
	else {
		$cmd .= sprintf("-r%04X ", $args{org});
	}

	exists($args{options})
		and $cmd .= $args{options} ." ";
	$cmd .= "@asm";
	
	ok 1, "$line $cmd";

	my($stdout, $stderr, $return) = capture {
		system $cmd;
	};
	
	my $errors;

	# check stdout
	$args{out} ||= ""; chomp($args{out}); chomp($stdout);
	$errors++ unless $stdout eq $args{out};
	is $stdout, $args{out}, "$line out";
	
	# check stderr
	$args{err} ||= ""; chomp($args{err}); chomp($stderr);
	my $exp_err_screen = my $exp_err_file = $args{err};
	if (! defined($args{bin})) {
		$exp_err_screen .= "\n1 errors occurred during assembly";
	}
	$errors++ unless $stderr eq $exp_err_screen;
	is $stderr, $exp_err_screen, "$line err";
	if ($stderr && $stderr !~ /option.*deprecated/) {	# option deprecated: before error file is created
		ok -f err_file(), "$line ".err_file();
		my $got_err_file = read_file(err_file(), err_mode => 'quiet') // "";
		chomp($got_err_file);
		is $exp_err_file, $got_err_file, "$line err file";
	}
	
	# check retval
	if (defined($args{bin})) {	# asm success
		$errors++ unless $return == 0;
		ok $return == 0, "$line exit value";
		
		# warning -> got_err_file
		# ok ! -f err_file(), "$line no ".err_file();
		
		ok -f $_, "$line $_" for (@obj, bin_file());
		
		# map file
		if ($cmd =~ / -nm /) {
			ok ! -f map_file(), "$line no ".map_file();
		}
		else {
			ok   -f map_file(), "$line ".map_file();
		}
		
		my $binary = read_file(bin_file(), binmode => ':raw', err_mode => 'quiet');
		t_binary($binary, $args{bin}, $line);
	}
	else {				# asm failed
		$errors++ unless $return != 0;
		ok $return != 0, "$line exit value";

		ok -f err_file(), "$line ".err_file();

		ok ! -f $_, "$line no $_" for (@obj, bin_file(), map_file());
		
		if ($cmd =~ / -x(\S+)/) {
			my $lib = $1;
			$lib .= ".lib" unless $lib =~ /\.lib$/i;
			
			ok ! -f $1, "$line no $lib";
		}
	}
	
	# list file or symbol table
	if (defined($args{bin})) {
		if ($cmd =~ / -l /) {
			ok   -f $_, "$line $_" for (@lst);
			ok ! -f $_, "$line no $_" for (@sym);
		}
		elsif ($cmd =~ / -ns /) {
			ok ! -f $_, "$line no $_" for (@lst);
			ok ! -f $_, "$line no $_" for (@sym);
		}
		else {
			ok ! -f $_, "$line no $_" for (@lst);
			ok   -f $_, "$line $_" for (@sym);
		}
	}
	else {
		ok ! -f $_, "$line no $_" for (@lst);
		ok ! -f $_, "$line no $_" for (@sym);
	}
	
	exit 1 if $errors && $STOP_ON_ERR;
}

#------------------------------------------------------------------------------
sub t_z80asm_error {
	my($code, $expected_err, $options) = @_;

	my $line = "[line ".((caller)[2])."]";
	(my $test_name = $code) =~ s/\n.*/.../s;
	ok 1, "$line t_z80asm_error $test_name - $expected_err";
	
	_unlink_files($line, @MAIN_TEST_FILES);
	write_file(asm_file(), "$code\n");
	
	my $cmd = z80asm()." ".($options || "")." ".asm_file();
	ok 1, "$line $cmd";
	my($stdout, $stderr, $return) = capture {
		system $cmd;
	};
	is $stdout, "", "$line stdout";
	is $stderr, $expected_err."\n".
				"1 errors occurred during assembly\n", "$line stderr";
	ok $return != 0, "$line exit value";
	ok -f err_file(), "$line error file found";
	ok ! -f obj_file(), "$line object file deleted";
	ok ! -f bin_file(), "$line binary file deleted";
	if (defined($options) && $options =~ /-x(\S+)/) {
		my $lib = $1;
		$lib .= ".lib" unless $lib =~ /\.lib$/i;
		
		ok ! -f $1, "$line library file deleted";
	}
	
	is read_file(err_file(), err_mode => 'quiet'), 
				$expected_err."\n", "$line error in error file";

	exit 1 if $return == 0 && $STOP_ON_ERR;
}

#------------------------------------------------------------------------------
sub t_z80asm_ok {
	my($address_hex, $code, $expected_binary, $options, $expected_warnings) = @_;

	$expected_warnings ||= "";
	chomp($expected_warnings);
	
	my $line = "[line ".((caller)[2])."]";
	(my $test_name = $code) =~ s/\n.*/.../s;
	ok 1, "$line t_z80asm_ok $test_name - ".
		hexdump(substr($expected_binary, 0, 16)).
		(length($expected_binary) > 16 ? "..." : "");
	
	_unlink_files($line, @MAIN_TEST_FILES);
	write_file(asm_file(), "org 0x$address_hex\n$code\n");
	
	my $cmd = z80asm()." -l -b ".($options || "")." ".asm_file();
	ok 1, "$line $cmd";
	my($stdout, $stderr, $return) = capture {
		system $cmd;
	};
	
	is $stdout, "", "$line stdout";
	chomp($stderr);
	is $stderr, $expected_warnings, "$line stderr";
	
	ok $return == 0, "$line exit value";
	ok ! -f err_file(), "$line no error file";
	ok -f bin_file(), "$line bin file found";
	
	my $binary = read_file(bin_file(), binmode => ':raw', err_mode => 'quiet');
	t_binary($binary, $expected_binary, $line);

	exit 1 if $return != 0 && $STOP_ON_ERR;
}

#------------------------------------------------------------------------------
sub t_binary {
	my($binary, $expected_binary, $test_name) = @_;
	
	$test_name //= "[line ".((caller)[2])."]";
	$binary //= "";
	$expected_binary //= "";
	my $ok = $binary eq $expected_binary;
	ok $ok, "$test_name binary";
	if (! $ok) {
		my $addr = 0;
		$addr++ while (substr($binary, $addr, 1) eq substr($expected_binary, $addr, 1));
		diag sprintf("$test_name Assembly differs at %04X:\n".
					 "	   got: %s\n".
					 "expected: %s\n", 
					 $addr, 
					 hexdump(substr($binary, $addr, 16)),
					 hexdump(substr($expected_binary, $addr, 16)));
		
		exit 1 if $STOP_ON_ERR;
	}
}

#------------------------------------------------------------------------------
sub t_z80asm_capture {
	my($args, $expected_out, $expected_err, $expected_retval) = @_;

	my $line = "[line ".((caller)[2])."]";
	ok 1, $line." t_z80asm_capture - ".z80asm()." ".$args;
	
	my($stdout, $stderr, $return) = capture {
		system z80asm()." ".$args;
	};

	is $stdout, $expected_out, "$line stdout";
	is $stderr, $expected_err, "$line stderr";
	ok !!$return == !!$expected_retval, "$line retval";
	
	exit 1 if $STOP_ON_ERR && 
			  ($stdout ne $expected_out ||
			   $stderr ne $expected_err ||
			   !!$return != !!$expected_retval);
}

#------------------------------------------------------------------------------
sub hexdump {
	return join(' ', map { sprintf("%02X", ord($_)) } split(//, shift));
}

#------------------------------------------------------------------------------
# return object file binary representation
sub objfile {
	my(%args) = @_;

	my $obj = "Z80RMF01";
	$obj .= pack("v", $args{ORG} // -1);

	# store empty pointers; mark position for later
	my $name_addr	 = length($obj); $obj .= pack("V", -1);
	my $expr_addr	 = length($obj); $obj .= pack("V", -1);
	my $symbols_addr = length($obj); $obj .= pack("V", -1);
	my $lib_addr	 = length($obj); $obj .= pack("V", -1);
	my $code_addr	 = length($obj); $obj .= pack("V", -1);

	# store expressions
	if ($args{EXPR}) {
		store_ptr(\$obj, $expr_addr);
		for (@{$args{EXPR}}) {
			my($type, $ptr, $string) = @$_;
			$obj .= $type . pack("v", $ptr) . pack_string($string) ."\0";
		}
	}

	# store symbols
	if ($args{SYMBOLS}) {
		store_ptr(\$obj, $symbols_addr);
		for (@{$args{SYMBOLS}}) {
			my($scope, $type, $value, $name) = @$_;
			$obj .= $scope . $type . pack("V", $value) . pack_string($name);
		}
	}

	# store library
	if ($args{LIBS}) {
		store_ptr(\$obj, $lib_addr);
		for my $name (@{$args{LIBS}}) {
			$obj .= pack_string($name);
		}
	}

	# store name
	store_ptr(\$obj, $name_addr);
	$obj .= pack_string($args{NAME});

	# store code
	if (length($args{CODE}) > 0) {
		store_ptr(\$obj, $code_addr);
		$obj .= pack("v", length($args{CODE}));
		$obj .= $args{CODE};
	}

	return $obj;
}

#------------------------------------------------------------------------------
# store a pointer to the end of the binary object at the given address
sub store_ptr {
	my($robj, $addr) = @_;
	my $ptr = length($$robj);
	my $packed_ptr = pack("V", $ptr);
	substr($$robj, $addr, length($packed_ptr)) = $packed_ptr;
}

#------------------------------------------------------------------------------
sub pack_string {
	my($string) = @_;
	return pack("C", length($string)).uc($string);
}

#------------------------------------------------------------------------------
sub read_binfile {
	my($file) = @_;
	ok -f $file, "$file exists";
	return scalar read_file($file, binmode => ':raw');
}

#------------------------------------------------------------------------------
# return library file binary representation
sub libfile {
	my(@obj_files) = @_;
	my $lib = 'Z80LMF01';
	for my $i (0 .. $#obj_files) {
		my $obj_file = $obj_files[$i];
		my $next_ptr = ($i == $#obj_files) ?
						-1 : length($lib) + 4 + 4 + length($obj_file);

		$lib .= pack("V", $next_ptr);
		$lib .= pack("V", length($obj_file));
		$lib .= $obj_file;
	}

	return $lib;
}

#------------------------------------------------------------------------------
sub t_compile_module {
	my($init_code, $main_code, $compile_args) = @_;

	# wait for previous run to finish
	while (-f 'test.exe' && ! unlink('test.exe')) {
		sleep(1);
	}
	
	my $cc = "cc -o test.exe test.c $compile_args";
	note "line ", (caller)[2], ": $cc";
	
	# create code skeleton
	$main_code = 
$init_code."
#include <stdlib.h>
#include <stdio.h>
int main (int argc, char **argv) {
".$main_code."
}
";
	while ($compile_args =~ /(\w+)\.[co]/ig) {
		$main_code = 
"#include \"$1.h\"
".$main_code;
	}
	
	write_file("test.c", $main_code);
	my $ok = (0 == system($cc));
	ok $ok;
	
	exit 1 if !$ok;	# no need to cotinue if compilation failed
}

#------------------------------------------------------------------------------
sub t_run_module {
	my($args, $expected_out, $expected_err, $expected_exit) = @_;
	
	note "line ", (caller)[2], ": test.exe @$args";
	my($out, $err, $exit) = capture { system("./test.exe", @$args) };
	note "line ", (caller)[2], ": exit ", $exit >> 8;
	
	$err = normalize($err);
	
	eq_or_diff_text $out, $expected_out;
	eq_or_diff_text $err, $expected_err;
	is !!$exit, !!$expected_exit;
	
	# if DEBUG, call wdiff to compare out and err with expected out and err
	if ($ENV{DEBUG} && $out.$err ne $expected_out.$expected_err) {
		my $temp_input = $0.".tmp";
		my @input = read_file($0);
		write_file($temp_input, @input[0 .. (caller)[2] - 1], $out, $err );
		system "wdiff \"$0\" \"$temp_input\"";
	}
	
	exit 1 if $STOP_ON_ERR && 
			  ($out ne $expected_out ||
			   $err ne $expected_err ||
			   !!$exit != !!$expected_exit);
}	

#------------------------------------------------------------------------------
# convert addresses to sequencial numbers
# convert line numbers to sequencial numbers
sub normalize {
	my($err) = @_;
	
	# MAP memory addresses - map only first occurrence of each address
	# as the OS may reuse addresses
	my $addr_seq; 
	for ($err) {
		while (my($addr) = /(\b(0x)+[0-9A-F]+\b)/i) {	# in Linux we get 0x0xHHHH
			$addr_seq++;
		
			# replace only first occurrence
			s/(alloc \d+ bytes at) $addr/$1 ADDR_$addr_seq/;
			s/(new class \w+ at) $addr/$1 ADDR_$addr_seq/;
			s/(delete class \w+ at) $addr/$1 ADDR_$addr_seq/;
			s/(free \d+ bytes at) $addr/$1 ADDR_$addr_seq/;
			s/(free memory leak of \d+ bytes at) $addr/$1 ADDR_$addr_seq/;
			s/(\w+_(init|fini|copy)) $addr/$1 ADDR_$addr_seq/g;
		}
	}
	
	# map code line numbers
	my %line_map;
	while ($err =~ /((\w+\.[ch])\((\d+)\))/gi) {
		$line_map{$2}{$3} = undef;
	}
	for my $file (keys %line_map) {
		my $count;
		for my $line (sort {$a <=> $b} keys %{$line_map{$file}}) {
			my $new_line = ++$count;
			$line_map{$file}{$line} = $new_line;
			$err =~ s/$file\($line\)/$file\($new_line\)/gi;
		}
	}
	
	# mask error number - random value on memory exception
	$err =~ s/(The value of errno was) \d+/$1 0/gi;
	$err =~ s/(thrown at \w+ \(\w+\.c):\d+/$1:0/gi;
	
	return $err;
}

#------------------------------------------------------------------------------
# get version and date from hist.c
sub get_copyright {
	my $hist = read_file("hist.c");
	my($version) = 	 $hist =~ /\#define \s+ VERSION   \s+ \" (.*?) \"/x or die;
	my($copyright) = $hist =~ /\#define \s+ COPYRIGHT \s+ \" (.*?) \"/x or die;
	my $copyrightmsg = "Z80 Module Assembler ".$version.", (c) ".$copyright;
	
	return $copyrightmsg;
}

#------------------------------------------------------------------------------
# get UNIX date from input text
sub get_unix_date {
	my($text) = @_;

	$text =~ /( (Mon|Tue|Wed|Thu|Fri|Sat|Sun) \s
				(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) \s
				\d\d \s \d\d:\d\d:\d\d \s \d\d\d\d
			  )/x
		or die "Date not found in $text";
	return $1;
}

#------------------------------------------------------------------------------
# LIST FILE HANDLING
#------------------------------------------------------------------------------
my $PAGE_SIZE = 61;
my $LINE_SIZE = 122;
my $MAX_LINE = 255-2;
my $COLUMN_WIDTH = 32;
my $LINENR; my @LINENR;
my $PAGENR;
my $PAGE_LINENR;
my $ADDR = 0;
my %LABEL_PAGE;
my %LABEL_ADDR;
my %LABEL_GLOBAL;
my @LIST_ASM;
my @LIST_BIN;
my @LIST_LST;
my $LABEL_RE = qr/\b[A-Z_][A-Z0-9_]*/;
my $LIST_ON = 1;

# pagination functions
sub list_first_line {
	$LINENR = 1;
	$PAGENR = 1;
	$PAGE_LINENR = 1;
}

# pagination functions
sub list_next_line {
	$LINENR++;
	$PAGE_LINENR++;
	if ($PAGE_LINENR > $PAGE_SIZE) {
		$PAGE_LINENR = 1;
		$PAGENR++;
	}
}

sub get_max_line  { $MAX_LINE }
sub get_num_lines { $LINENR   }

#------------------------------------------------------------------------------
# push list line - interpreets any ALL_CAPS word as a label
sub list_push_asm {
	my($asm, @bytes) = @_;

	my $new_list_on = $LIST_ON;
	
	# handle asm, interpreet labels
	if ($asm) {				
		push @LIST_ASM, $asm unless @LINENR;		# not if inside include
		
		if ($asm =~ /^\s*($LABEL_RE)\s*:/) {		# define label
			unshift @{$LABEL_PAGE{$1}}, $PAGENR;
			$LABEL_PAGE{$1} ||= [];
			$LABEL_ADDR{$1} = $ADDR;
		}
		elsif ($asm =~ /^\s*defc\s+($LABEL_RE)\s*=\s*(.*)/) {		# define constant
			unshift @{$LABEL_PAGE{$1}}, $PAGENR;
			$LABEL_PAGE{$1} ||= [];
			$LABEL_ADDR{$1} = 0+eval($2);
		}
		elsif ($asm =~ /(?i:xdef|xlib)\s+($LABEL_RE)/) {	# global label
			push @{$LABEL_PAGE{$1}}, $PAGENR;
			$LABEL_GLOBAL{$1}++;
		}
		elsif ($asm =~ /^\s*lstoff\s*$/i) {
			$new_list_on = 0;
		}
		elsif ($asm =~ /^\s*lston\s*$/i) {
			$new_list_on = 1;
		}
		else {
			push @{$LABEL_PAGE{$1}}, $PAGENR while $asm =~ /($LABEL_RE)/g;	# use label
		}
	}
	
	# handle bin
	push @LIST_BIN, pack("C*", @bytes);
	
	# handle list
	my $lst = sprintf("%-5d %04X  ", $LINENR, $ADDR);
	
	my @lst_bytes = @bytes;
	while (@lst_bytes) {
		my @lst_block = splice(@lst_bytes, 0, 32);
		$lst .= join('', map {sprintf("%02X ", $_)} @lst_block);
		$ADDR += @lst_block;

		# still for another row?
		if (@lst_bytes) {
			if ($LIST_ON) {
				push @LIST_LST, $lst;
				list_next_line(); $LINENR--;
			}
			$lst = sprintf("%5s %04X  ", "", $ADDR);
		}
	}
	
	# assembly
	if (@bytes <= 4) {
		$lst = sprintf("%-24s%s", $lst, $asm // '');
	}
	else {
		if ($LIST_ON) {
			push @LIST_LST, $lst;
			list_next_line(); $LINENR--;
		}
		$lst = sprintf("%-24s%s", "", $asm // '');
	}		

	if ($LIST_ON) {
		push @LIST_LST, $lst;
		list_next_line();
	}
	else {
		$LINENR++;
	}
	
	$LIST_ON = $new_list_on;
}

# hanble includes
sub list_push_include {
	my($file) = @_;
	list_push_asm("include \"$file\"");
	push @LINENR, $LINENR;
	$LINENR = 1;
}

sub list_pop_include {
	list_push_asm();
	@LINENR or die;
	$LINENR = pop(@LINENR);
}
	
#------------------------------------------------------------------------------
# compare result file with list of expected lines
sub compare_list_file {
	my($file, @expected) = @_;

	my $line = "[line ".((caller)[2])."]";

	my @got = read_file($file);
	chomp(@got);
	
	insert_headers(get_copyright(), get_unix_date($got[0]), $file, \@expected);
	
	eq_or_diff \@got, \@expected, "$line compare $file";
}

#------------------------------------------------------------------------------
# insert headers every $PAGE_SIZE lines
sub insert_headers {
	my($copyright, $date, $file, $lines) = @_;
	my $i = 0;
	my $page = 1;
	
	while ($i <= @$lines) {
		my @insert;
		push @insert, "\f" if $i > 0;
		push @insert, $copyright . " " x ($LINE_SIZE - length($copyright) - length($date)) . $date;
		push @insert, "Page ".sprintf("%03d", $page) . " " x ($LINE_SIZE - 10 - length($file)) . "'$file'";
		push @insert, "";
		push @insert, "";
		
		splice(@$lines, $i, 0, @insert);
		
		$page++;
		$i += @insert + $PAGE_SIZE;
	}
	push @$lines, "\f";
}

#------------------------------------------------------------------------------
# Return list of lines of symbol table
sub sym_lines {
	my($show_pages) = @_;
	my @sym;
	
	push @sym, "";
	push @sym, "";
	push @sym, "Local Module Symbols:";
	push @sym, "";
	
	for (sort {uc($a) cmp uc($b)} keys %LABEL_ADDR) {
		push @sym, format_sym_line($_, $show_pages) unless $LABEL_GLOBAL{$_};
	}
	
	push @sym, "";
	push @sym, "";
	push @sym, "Global Module Symbols:";
	push @sym, "";
	
	for (sort {uc($a) cmp uc($b)} keys %LABEL_ADDR) {
		push @sym, format_sym_line($_, $show_pages) if $LABEL_GLOBAL{$_};
	}
	
	return @sym;
}

#------------------------------------------------------------------------------
sub format_sym_line {
	my($label, $show_pages) = @_;
	my @ret;
	
	my $line = uc($label);
	if (length($line) >= $COLUMN_WIDTH) {
		push @ret, $line;
		$line = '';
	}
	$line .= sprintf("%-*s= %08X", $COLUMN_WIDTH - length($line), '', $LABEL_ADDR{$label});
	
	if ($show_pages) {
		$line .= " :";
		
		my @pages = uniq @{$LABEL_PAGE{$label}};
		my $first = 1;
		while (my @block = splice(@pages, 0, 15)) {
			my $page = shift @block;
			$line .= sprintf("%4d%s", $page, $first ? '*' : ' ');
			$first = 0;
			
			while (@block) {
				my $page = shift @block;
				$line .= sprintf("%4d ", $page);
			}
			
			if (@pages) {
				push @ret, $line;
				$line = sprintf("%*s", $COLUMN_WIDTH + 2 + 8 + 2, '');
			}
		}
	}
	push @ret, $line;
	
	return @ret;
}

#------------------------------------------------------------------------------
# test list file
sub list_test {
	my $asm = join("\n", @LIST_ASM);
	my $bin = join('',   @LIST_BIN);

	list_push_asm();
	
	for my $options ("-ns -nl", "-nl -ns") {
		t_z80asm(
			asm		=> $asm,
			bin		=> $bin,
			options	=> "-ns -nl",
			nolist	=> 1,
		);
		ok ! -f lst_file(), "no ".lst_file();
		ok ! -f sym_file(), "no ".sym_file();
	}
	
	for my $options ("-ns -l", "-l -ns") {
		t_z80asm(
			asm		=> $asm,
			bin		=> $bin,
			options	=> "-ns -l",
			nolist	=> 1,
		);
		ok   -f lst_file(), lst_file();
		ok ! -f sym_file(), "no ".sym_file();
		compare_list_file(lst_file(), @LIST_LST);
	}
	
	for my $options ("", "-nl", "-s", "-s -nl", "-nl -s") {
		t_z80asm(
			asm		=> $asm,
			bin		=> $bin,
			options	=> "-s -nl",
			nolist	=> 1,
		);
		ok ! -f lst_file(), "no ".lst_file();
		ok   -f sym_file(), sym_file();
		compare_list_file(sym_file(), sym_lines(0));
	}
	
	for my $options ("-l", "-s -l", "-l -s") {
		t_z80asm(
			asm		=> $asm,
			bin		=> $bin,
			options	=> "-s -l",
			nolist	=> 1,
		);
		ok   -f lst_file(), lst_file();
		ok ! -f sym_file(), "no ".sym_file();
		compare_list_file(lst_file(), @LIST_LST, sym_lines(1));
	}
}

list_first_line();

1;
