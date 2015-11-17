#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2015
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Common utils for tests

use Modern::Perl;
use File::Slurp;
use Capture::Tiny::Extended 'capture';
use Test::Differences; 
use List::AllUtils 'uniq';
use Data::HexDump;

my $OBJ_FILE_VERSION = "08";
my $STOP_ON_ERR = grep {/-stop/} @ARGV; 
my $KEEP_FILES	= grep {/-keep/} @ARGV; 
my $test	 = "test";

sub z80asm	 { $ENV{Z80ASM} || "./z80asm" }

my @TEST_EXT = (qw( asm lst inc bin map obj lib sym def err 
					exe c o asmlst prj i reloc ));
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
		_unlink_files($line, @TEST_FILES, @additional_files, <test*.bin>, <test*.reloc>);
	}
}

#------------------------------------------------------------------------------
# Args:
#	asm, asm1, asm2, ... : source text, asm is main file; can use " : " to split lines
#	org : -1 to skip -r0 option, >= 0 to define -r{org}, undef for -r0, org = decimal value
# 	options : additional assemble options
#   out : expected output, if any
#   err : expected compile errors, if any
#   linkerr : expected link errors, if any
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
	$args{err} ||= ""; $args{linkerr} ||= ""; 
	chomp($args{err}); chomp($args{linkerr}); chomp($stderr);
	my $exp_err_screen = my $exp_err_file = $args{err}.$args{linkerr};
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
		if ($cmd =~ / (-nm|--no-map) /) {
			ok ! -f map_file(), "$line no ".map_file();
		}
		else {
			ok   -f map_file(), "$line ".map_file();
		}
		
		my $binary = read_file(bin_file(), binmode => ':raw', err_mode => 'quiet');
		t_binary($binary, $args{bin}, $line);
	}
	elsif ($args{linkerr}) {	# asm OK but link failed
		$errors++ unless $return != 0;
		ok $return != 0, "$line exit value";

		ok -f err_file(), "$line ".err_file();

		ok -f $_, "$line $_" for (@obj);
		ok ! -f $_, "$line no $_" for (bin_file(), map_file());
		
		if ($cmd =~ / -x(\S+)/) {
			my $lib = $1;
			$lib .= ".lib" unless $lib =~ /\.lib$/i;
			
			ok ! -f $1, "$line no $lib";
		}
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
		if ($cmd =~ / (-l|--list) /) {
			ok   -f $_, "$line $_" for (@lst);
			ok ! -f $_, "$line no $_" for (@sym);
		}
		elsif ($cmd =~ / (-ns|--no-symtable) /) {
			ok ! -f $_, "$line no $_" for (@lst);
			ok ! -f $_, "$line no $_" for (@sym);
		}
		else {
			ok ! -f $_, "$line no $_" for (@lst);
			ok   -f $_, "$line $_" for (@sym);
		}
	}
	elsif ($args{linkerr}) {	# asm OK but link failed
		ok -f $_, "$line $_" for (@lst);
		ok ! -f $_, "$line no $_" for (@sym);
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
					 ".....got: %s\n".
					 "expected: %s\n", 
					 $addr, 
					 hexdump(substr($binary, $addr, 16)),
					 hexdump(substr($expected_binary, $addr, 16)));
		
		# show winmergeu
		if ($ENV{DEBUG}) {
			write_file("test.binary.got", 		HexDump($binary));
			write_file("test.binary.expected", 	HexDump($expected_binary));
			system "winmergeu test.binary.got test.binary.expected";
			die "aborted";
		}
		
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

	eq_or_diff_text $stdout, $expected_out, "$line stdout";
	eq_or_diff_text $stderr, $expected_err, "$line stderr";
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

	exists($args{ORG}) and die;
	
	my $obj = "Z80RMF".$OBJ_FILE_VERSION;

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
			@$_ == 8 or die;
			my($type, $filename, $line_nr, $section, $asmptr, $ptr, $target_name, $text) = @$_;
			$obj .= $type . pack_lstring($filename) . pack("V", $line_nr) .
			        pack_string($section) . pack("vv", $asmptr, $ptr) . 
					pack_string($target_name) . pack_lstring($text);
		}
		$obj .= "\0";
	}

	# store symbols
	if ($args{SYMBOLS}) {
		store_ptr(\$obj, $symbols_addr);
		for (@{$args{SYMBOLS}}) {
			@$_ == 5 or die;
			my($scope, $type, $section, $value, $name) = @$_;
			$obj .= $scope . $type . pack_string($section) . 
					pack("V", $value) . pack_string($name);
		}
		$obj .= "\0";
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
	if ( $args{CODE} ) {
		ref($args{CODE}) eq 'ARRAY' or die;
		store_ptr(\$obj, $code_addr);
		for (@{$args{CODE}}) {
			@$_ == 3 or die;
			my($section, $org, $code) = @$_;
			$obj .= pack("V", length($code)) . 
			        pack_string($section) . 
					pack("V", $org) . 
					$code;
		}
		$obj .= pack("V", -1);
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
	return pack("C", length($string)).$string;
}

#------------------------------------------------------------------------------
sub pack_lstring {
	my($string) = @_;
	return pack("v", length($string)).$string;
}

#------------------------------------------------------------------------------
sub read_binfile {
	my($file) = @_;
	ok -f $file, "$file exists";
	return scalar read_file($file, binmode => ':raw');
}

#------------------------------------------------------------------------------
sub write_binfile {
	my($file, $data) = @_;
	write_file($file, {binmode => ':raw'}, $data);
}

#------------------------------------------------------------------------------
# return library file binary representation
sub libfile {
	my(@obj_files) = @_;
	my $lib = "Z80LMF".$OBJ_FILE_VERSION;
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

	# modules to include always
	$compile_args .= " -DMEMALLOC_DEBUG lib/alloc.c lib/strpool.o";
	
	# wait for previous run to finish
	while (-f 'test.exe' && ! unlink('test.exe')) {
		sleep(1);
	}
	
	my($CFLAGS, $LDFLAGS) = get_gcc_options();
	
	# get list of object files
	my %modules;
	while ($compile_args =~ /(\S+)\.[co]\b/ig) {
		$modules{$1}++;
	}

	# make modules (once per run)
	our %made_modules;
	my @make_modules;
	for (keys %modules) {
		push @make_modules, "$_.o" unless $made_modules{$_}++;
	}
	if (@make_modules) {
		my $make = "make @make_modules";
		note "line ", (caller)[2], ": $make";
		
		my $ok = (0 == system($make));
		ok $ok, "make";
		
		exit 1 if !$ok;	# no need to cotinue if compilation failed
	}
	
	# create code skeleton
	$main_code = "
#include <stdlib.h>
#include <stdio.h>

".join("\n", map {"#include \"$_\""} grep {-f $_} map {"$_.h"} sort keys %modules)."\n".'
#undef main

#define TITLE(title)	fprintf(stderr, "\n---- TEST: %s ----\n\n", (title) )

#define TEST_DIE(err_condition, err_message, expr_str) \
			do { \
				if ( err_condition ) { \
					fprintf(stderr, err_message " (%s) at file %s, line %d\n", \
									expr_str, __FILE__, __LINE__); \
					exit(1); \
				} \
			} while(0)

#define ASSERT(expr) 			TEST_DIE( ! (expr), "TEST FAILED", #expr )

void dump_file ( char *filename )
{
	FILE *fp;
	int addr, c;
	
	ASSERT( fp = fopen( filename, "rb") );
	
	fprintf(stderr, "File: %s:", filename);
	for ( addr = 0; (c = fgetc(fp)) != EOF; addr++ ) {
		if (addr % 16 == 0)
			fprintf(stderr, "\n%4X  ", addr);
		if (c > 0x20 && c < 0x7F)
			fprintf(stderr, " %1c   ", c);
		else
			fprintf(stderr, "<%02X> ", c);
	}
	fprintf(stderr, "\n");
	fclose(fp);
}
'.$init_code.'
int main (int argc, char **argv) 
{
	{
'.$main_code."
	}
	
	return 0;
}

";
	
	write_file("test.c", $main_code);

	# build
	my $cc = "cc $CFLAGS -o test.exe test.c $compile_args $LDFLAGS";
	note "line ", (caller)[2], ": $cc";
	
	my $ok = (0 == system($cc));
	ok $ok, "cc";
	
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
	
	# if DEBUG, call winmergeu to compare out and err with expected out and err
	if ($ENV{DEBUG} && $out."##".$err ne $expected_out."##".$expected_err) {
		my $temp_input = $0.".tmp";
		my @input = read_file($0);
		write_file($temp_input, @input[0 .. (caller)[2] - 1], $out, "OUT\n", $err, "ERR\n" );
		system "winmergeu \"$0\" \"$temp_input\"";
		die "aborted";
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
	my $sentence_re = qr/alloc \d+ bytes at|new class \w+ at|delete class \w+ at|free \d+ bytes at|free memory leak of \d+ bytes at|\w+_(?:init|fini|copy)/;
	
	my $addr_seq; 
	for ($err) {
		while (my($sentence, $addr) = /($sentence_re) ((0x)+[0-9A-F]+\b)/i) {	# in Linux we get 0x0xHHHH
			$addr_seq++;
		
			# replace only first occurrence
			s/(alloc \d+ bytes at) $addr/$1 ADDR_$addr_seq/;
			s/(new class \w+ at) $addr/$1 ADDR_$addr_seq/;
			s/(delete class \w+ at) $addr/$1 ADDR_$addr_seq/;
			s/(free \d+ bytes at) $addr/$1 ADDR_$addr_seq/;
			s/(free memory leak of \d+ bytes at) $addr/$1 ADDR_$addr_seq/;
			s/(\w+_init) $addr/$1 ADDR_$addr_seq/g;
			s/(\w+_fini) $addr/$1 ADDR_$addr_seq/g;
			s/(\w+_copy) $addr/$1 ADDR_$addr_seq/g;
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
my $LINENR; my @LINENR_STACK;
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
		push @LIST_ASM, $asm unless @LINENR_STACK;		# not if inside include
		
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
		elsif ($asm =~ /(?i:xdef|xlib|public)\s+($LABEL_RE)/) {	# global label
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
	push @LINENR_STACK, $LINENR;
	$LINENR = 1;
}

sub list_pop_include {
	list_push_asm();
	@LINENR_STACK or die;
	$LINENR = pop(@LINENR_STACK);
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
	
	for (sort {$a cmp $b} keys %LABEL_ADDR) {
		push @sym, format_sym_line($_, $show_pages) unless $LABEL_GLOBAL{$_};
	}
	
	push @sym, "";
	push @sym, "";
	push @sym, "Global Module Symbols:";
	push @sym, "";
	
	for (sort {$a cmp $b} keys %LABEL_ADDR) {
		push @sym, format_sym_line($_, $show_pages) if $LABEL_GLOBAL{$_};
	}
	
	return @sym;
}

#------------------------------------------------------------------------------
sub format_sym_line {
	my($label, $show_pages) = @_;
	my @ret;
	
	my $line = $label;
	if (length($line) >= $COLUMN_WIDTH) {
		push @ret, $line;
		$line = '';
	}
	$line .= sprintf("%-*s= %04X", $COLUMN_WIDTH - length($line), '', $LABEL_ADDR{$label});
	
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
			options	=> $options,
			nolist	=> 1,
		);
		ok ! -f lst_file(), "no ".lst_file();
		ok ! -f sym_file(), "no ".sym_file();
	}
	
	for my $options ("-ns -l", "-l -ns") {
		t_z80asm(
			asm		=> $asm,
			bin		=> $bin,
			options	=> $options,
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
			options	=> $options,
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
			options	=> $options,
			nolist	=> 1,
		);
		ok   -f lst_file(), lst_file();
		ok ! -f sym_file(), "no ".sym_file();
		compare_list_file(lst_file(), @LIST_LST, sym_lines(1));
	}
}

list_first_line();

#------------------------------------------------------------------------------
# Get compilation options
#------------------------------------------------------------------------------
sub get_gcc_options {
	our %FLAGS;
	
	# hack
	$ENV{LOCAL_LIB} = "lib";
	
	if ( ! %FLAGS ) {
		open(my $pipe, "make -p|") or die;
		while (<$pipe>) {
			if (/^(CFLAGS|LDFLAGS)\s*=\s*(.*)/) {
				my($flag, $text) = ($1, $2);
				$text =~ s/\$\((\w+)\)/ $ENV{$1} /ge;
				$text =~ s/\$\(shell (.*?)\)/ `$1` /ge;
				$text =~ s/\s+/ /g;
				
				$FLAGS{$flag} = $text;
				last if scalar keys %FLAGS == 2;
			}
		}
		close($pipe) or die;
		$FLAGS{CFLAGS}  ||= '';
		$FLAGS{LDFLAGS} ||= '';
	}
	
	return @FLAGS{qw( CFLAGS LDFLAGS )};
};

1;
