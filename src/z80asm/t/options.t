#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Test options

use strict;
use warnings;
use File::Slurp;
use File::Basename;
use File::Copy;
use Time::HiRes 'sleep';
use Capture::Tiny 'capture_merged';
use Test::Differences; 
use Test::More;
require 't/test_utils.pl';

my $copyrightmsg = get_copyright()."\n";

#------------------------------------------------------------------------------
# no arguments
#------------------------------------------------------------------------------
unlink_testfiles();
t_z80asm_capture("", 		$copyrightmsg, 	"", 0);

#------------------------------------------------------------------------------
# list of files
#------------------------------------------------------------------------------
unlink_testfiles();
write_file("test1.asm", "defb 1");
write_file("test2.asm", "defb 2");
write_file("test3.asm", "defb 3");
write_file("test4.asm", "defb 4");

t_z80asm_capture('-b test1.asm test2.asm test3.asm test4.asm', "", "", 0);
t_binary(read_binfile("test1.bin"), "\1\2\3\4");
ok unlink "test1.bin";

# list file with blank lines and comments
write_binfile("test1.lst", <<'END');
; comment followed by blank line

# comment
   test2.asm  
@  test2.lst  
END

# list file with different EOL chars
write_binfile("test2.lst", "\r\r\n\n  "."test3.asm"."  \r\r\n\n    "."test4.asm"."\n");
t_z80asm_capture('-b test1.asm @test1.lst', "", "", 0);
t_binary(read_binfile("test1.bin"), "\1\2\3\4");
ok unlink "test1.bin";

# recursive includes
write_binfile("test1.lst", "\r\r\n\n  "."test2.asm"."  \r\r\n\n  \@ "."test2.lst");
write_binfile("test2.lst", "\r\r\n\n  "."test2.asm"."  \r\r\n\n  \@ "."test1.lst");
t_z80asm_capture('-b test1.asm @test1.lst', "", <<'ERR', 1);
Error at file 'test2.lst' line 7: cannot include file 'test1.lst' recursively
1 errors occurred during assembly
ERR

# expand environment variables in source and list files
$ENV{TEST_ENV} = 'test';

t_z80asm_capture('-b ${TEST_ENV}1.asm ${TEST_ENV}2.asm ${TEST_ENV}3.asm ${TEST_ENV}4.asm', "", "", 0);
t_binary(read_binfile("test1.bin"), "\1\2\3\4");
ok unlink "test1.bin";

write_binfile("test1.lst", <<'END');
${TEST_ENV}1.asm
${TEST_ENV}2.asm
${TEST_ENV}3.asm
${TEST_ENV}4.asm
END

t_z80asm_capture('-b @test1.lst', "", "", 0);
t_binary(read_binfile("test1.bin"), "\1\2\3\4");
ok unlink "test1.bin";

# non-existent environment variable is empty
delete $ENV{TEST_ENV};

t_z80asm_capture('-b test${TEST_ENV}1.asm test${TEST_ENV}2.asm test${TEST_ENV}3.asm test${TEST_ENV}4.asm', "", "", 0);
t_binary(read_binfile("test1.bin"), "\1\2\3\4");
ok unlink "test1.bin";

write_binfile("test1.lst", <<'END');
test${TEST_ENV}1.asm
test${TEST_ENV}2.asm
test${TEST_ENV}3.asm
test${TEST_ENV}4.asm
END

t_z80asm_capture('-b @test1.lst', "", "", 0);
t_binary(read_binfile("test1.bin"), "\1\2\3\4");
ok unlink "test1.bin";

#------------------------------------------------------------------------------
# --help, -h
#------------------------------------------------------------------------------
my $help_text = $copyrightmsg . <<'END';

Usage:
  z80asm [options] { @<modulefile> | <filename> }

  [] = optional, {} = may be repeated, | = OR clause.

  To assemble 'fred.asm' use 'fred' or 'fred.asm'

  <modulefile> contains list of file names of all modules to be linked,
  one module per line.

  File types recognized or created by z80asm:
    .asm   = source file
    .o     = object file
    .lis   = list file
    .bin   = Z80 binary file
    .sym   = symbols file
    .map   = map file
    .reloc = reloc file
    .def   = global address definition file
    .err   = error file

Help Options:
  -h, --help             Show help options
  -v, --verbose          Be verbose

Code Generation Options:
  --cpu=z180             Assemble for the Z180
  --RCMX000              Assemble for RCM2000/RCM3000 series of Z80-like CPU
  --ti83plus             Interpret 'Invoke' as RST 28h
  --IXIY                 Swap IX and IY registers
  -C, --line-mode        Enable LINE directive

Environment:
  -I, --inc-path=PATH    Add directory to include search path
  -L, --lib-path=PATH    Add directory to library search path
  -D, --define=SYMBOL    Define a static symbol

Libraries:
  -x, --make-lib=FILE    Create a library file.lib
  -i, --use-lib=FILE     Link library file.lib

Binary Output:
  -o, --output=FILE      Output binary file
  -b, --make-bin         Assemble and link/relocate to file.bin
  --split-bin            Create one binary file per section
  -d, --date-stamp       Assemble only updated files
  -r, --origin=ADDR      Relocate binary file to given address (decimal or hex)
  -R, --relocatable      Create relocatable code
  --reloc-info           Geneate binary file relocation information

Output File Options:
  -s, --symtable         Create symbol table file.sym
  -l, --list             Create listing file.lis
  -m, --map              Create address map file.map
  -g, --globaldef        Create global definition file.def
END

unlink_testfiles();
t_z80asm_capture("-h", 		$help_text, 	"", 0);
t_z80asm_capture("--help", 	$help_text, 	"", 0);

# make sure help fist in 80 columns
my $out = capture_merged { system z80asm()." --help"; };
my @long_lines = grep {length > 80} split(/\n/, $out);
ok !@long_lines, "help within 80 columns";
diag join("\n", @long_lines) if @long_lines;

# check no arguments
t_z80asm_capture("-h=x", 	"", 	<<'ERR', 1);
Error: illegal option '-h=x'
Error: source filename missing
2 errors occurred during assembly
ERR

t_z80asm_capture("--help=x", 	"", 	<<'ERR', 1);
Error: illegal option '--help=x'
Error: source filename missing
2 errors occurred during assembly
ERR

#------------------------------------------------------------------------------
# --verbose, -v
#------------------------------------------------------------------------------
my $verbose_text = <<'END';
Assembling 'test.asm' to 'test.o'
Reading 'test.asm'
Module 'test' size: 3 bytes

Code size: 3 bytes ($0000 to $0002)
END

for my $options ('-v', '--verbose') {
	unlink_testfiles();
	write_file(asm_file(), " nop \n nop \n nop");
	t_z80asm_capture("-b -d -s -l -g $options ".asm_file(), 
					$verbose_text, "", 0);
	ok -f o_file();
	ok -f bin_file();
	is read_file(bin_file(), binmode => ':raw'), "\0\0\0";
	
	unlink_testfiles();
	write_file(asm_file(), " nop \n nop \n nop");
	t_z80asm_capture("-b -s -l -g $options ".asm_file(), 
					$verbose_text, "", 0);
	ok -f o_file();
	ok -f bin_file();
	is read_file(bin_file(), binmode => ':raw'), "\0\0\0";
	
}

# check no arguments
t_z80asm_capture("-v=x", 	"", 	<<'ERR', 1);
Error: illegal option '-v=x'
Error: source filename missing
2 errors occurred during assembly
ERR

t_z80asm_capture("--verbose=x", 	"", 	<<'ERR', 1);
Error: illegal option '--verbose=x'
Error: source filename missing
2 errors occurred during assembly
ERR

# not verbose
unlink_testfiles();
write_file(asm_file(), "nop");
t_z80asm_capture("-b ".asm_file(), "", "", 0);
is read_file(bin_file(), binmode => ':raw'), "\0";

# check no arguments
t_z80asm_capture("-nv=x", 	"", 	<<'ERR', 1);
Error: illegal option '-nv=x'
Error: source filename missing
2 errors occurred during assembly
ERR

t_z80asm_capture("--not-verbose=x", 	"", 	<<'ERR', 1);
Error: illegal option '--not-verbose=x'
Error: source filename missing
2 errors occurred during assembly
ERR

#------------------------------------------------------------------------------
# asm extension
#------------------------------------------------------------------------------
for my $file ('test', 'test.asm') {
	unlink_testfiles();
	write_file('test.asm', "ret");
	t_z80asm_capture("-b $file", "", "", 0);
	is read_file(bin_file(), binary => ':raw'), "\xC9", "assemble ok";
}

unlink_testfiles();
write_file('test.xxx', "ret");
t_z80asm_capture("-b test.xxx", "", "", 0);
is read_file(bin_file(), binary => ':raw'), "\xC9", "assemble ok";

unlink_testfiles('test.xxx');

#------------------------------------------------------------------------------
# o extension
#------------------------------------------------------------------------------
for my $file ('test', 'test.o') {
	unlink_testfiles();
	write_file('test.asm', "ret");
	t_z80asm_capture("-b $file", "", "", 0);
	is read_file(bin_file(), binary => ':raw'), "\xC9", "assemble ok";
	
	unlink(bin_file(), 'test.asm');
	t_z80asm_capture("-b $file", "", "", 0);
	is read_file(bin_file(), binary => ':raw'), "\xC9", "assemble ok";
}

#------------------------------------------------------------------------------
# -s, --symtable
#------------------------------------------------------------------------------
unlink_testfiles();

my $asm = "
	PUBLIC main
main:	ld b,10
loop:	djnz loop
	ret
";
my $bin = pack("C*", 
	0x06, 10,
	0x10, -2 & 0xFF,
	0xC9
);

# no symbol table
t_z80asm(
	asm		=> $asm,
	bin		=> $bin,
	options	=> "",
);

# symbol table
for my $options ('-s', '--symtable') {
	t_z80asm(
		asm		=> $asm,
		bin		=> $bin,
		options	=> $options,
	);
}

#------------------------------------------------------------------------------
# -l, --list
#------------------------------------------------------------------------------
unlink_testfiles();

$asm = "
	PUBLIC main
main:	ld b,10
loop:	djnz loop
	ret
";
$bin = pack("C*", 
	0x06, 10,
	0x10, -2 & 0xFF,
	0xC9
);

# no list
t_z80asm(
	asm		=> $asm,
	bin		=> $bin,
	options	=> "",
	nolist	=> 1,
);


# list file
for my $options ('-l', '--list') {
	t_z80asm(
		asm		=> $asm,
		bin		=> $bin,
		options	=> $options,
		nolist	=> 1,
	);
}

#------------------------------------------------------------------------------
# -m, --map
#------------------------------------------------------------------------------
note "BUG_0036";
$asm = "
	define not_shown
	defc zero=0
	PUBLIC main
main: ld b,10
loop: djnz loop
	PUBLIC last
last:
x31_x31_x31_x31_x31_x31_x31_x31: defb zero
x_32_x32_x32_x32_x32_x32_x32_x32: defb zero
";
my $asm2 = "
	define not_shown
	
	; show DEFC alias in map file
	PUBLIC alias_main
	EXTERN main
	defc alias_main = main
	
	PUBLIC alias_last
	EXTERN last
	defc alias_last = last

	PUBLIC func
func: ld b,10
loop: djnz loop
	  ret
";
$bin = "\x06\x0A\x10\xFE\x00\x00\x06\x0A\x10\xFE\xC9";

# no -m
t_z80asm(
	asm		=> "ld b,10 : djnz ASMPC : defw 0",
	asm2	=> "ld b,10 : djnz ASMPC : ret",
	bin		=> $bin,
);
ok ! -f map_file(), map_file();

# -m, no symbols
for my $options ('-m', '--map') {
	t_z80asm(
		asm		=> "ld b,10 : djnz ASMPC : defw 0",
		asm2	=> "ld b,10 : djnz ASMPC : ret",
		bin		=> $bin,
		options	=> $options,
	);
	ok -f map_file(), map_file();
	eq_or_diff scalar(read_file(map_file())), <<'END', "mapfile contents";
__head                          = $0000 ; G 
__size                          = $000B ; G 
__tail                          = $000B ; G 
END
}

# -m
t_z80asm(
	asm		=> $asm,
	asm2	=> $asm2,
	bin		=> $bin,
	options	=> '-m',
);
ok -f map_file(), map_file();
eq_or_diff scalar(read_file(map_file())), <<'END', "mapfile contents";
__head                          = $0000 ; G 
alias_main                      = $0000 ; G test2
main                            = $0000 ; G test
zero                            = $0000 ; L test
loop                            = $0002 ; L test
alias_last                      = $0004 ; G test2
last                            = $0004 ; G test
x31_x31_x31_x31_x31_x31_x31_x31 = $0004 ; L test
x_32_x32_x32_x32_x32_x32_x32_x32 = $0005 ; L test
func                            = $0006 ; G test2
loop                            = $0008 ; L test2
__size                          = $000B ; G 
__tail                          = $000B ; G 
END

#------------------------------------------------------------------------------
# -g, --globaldef
#------------------------------------------------------------------------------
$asm = "
	PUBLIC main, x31_x31_x31_x31_x31_x31_x31_x31, x_32_x32_x32_x32_x32_x32_x32_x32
main: ld b,10
loop: djnz loop
	PUBLIC last
last:
x31_x31_x31_x31_x31_x31_x31_x31: defb 0
x_32_x32_x32_x32_x32_x32_x32_x32: defb 0
";
$asm2 = "

	; show DEFC alias in map file
	PUBLIC alias_main
	EXTERN main
	defc alias_main = main
	
	PUBLIC alias_last
	EXTERN last
	defc alias_last = last

	PUBLIC func
func: ret
";
$bin = "\x06\x0A\x10\xFE\x00\x00\xC9";

# no -g
t_z80asm(
	asm		=> $asm,
	asm2	=> $asm2,
	bin		=> $bin,
	options	=> "",
);
ok ! -f def_file(), "no ".def_file();

# -g
for my $options ('-g', '--globaldef') {
	t_z80asm(
		asm		=> $asm,
		asm2	=> $asm2,
		bin		=> $bin,
		options	=> $options,
	);
	ok -f def_file(), def_file();
	eq_or_diff scalar(read_file(def_file())), <<'END', "deffile contents";
DEFC alias_main                      = $0000 ;   test2
DEFC main                            = $0000 ;   test
DEFC alias_last                      = $0004 ;   test2
DEFC last                            = $0004 ;   test
DEFC x31_x31_x31_x31_x31_x31_x31_x31 = $0004 ;   test
DEFC x_32_x32_x32_x32_x32_x32_x32_x32 = $0005 ;   test
DEFC func                            = $0006 ;   test2
END
}

#------------------------------------------------------------------------------
# -b, --make-bin
#------------------------------------------------------------------------------

# no -b
unlink_testfiles();
write_file(asm_file(), "nop");

t_z80asm_capture(asm_file(), "", "", 0);
ok -f o_file();
ok ! -f bin_file();

# -b
for my $options ('-b', '--make-bin') {
	unlink_testfiles();
	write_file(asm_file(), "nop");

	t_z80asm_capture("$options ".asm_file(), "", "", 0);
	ok -f o_file();
	ok -f bin_file();
	is read_file(bin_file(), binmode => ':raw'), "\0";
}

#------------------------------------------------------------------------------
# -o, --output
#------------------------------------------------------------------------------
$bin = bin_file(); $bin =~ s/\.bin$/2.bin/i;

# no -o
unlink_testfiles($bin);
write_file(asm_file(), "nop");

t_z80asm_capture("-b ".asm_file(), "", "", 0);
ok -f bin_file();
ok ! -f $bin;
t_binary(read_file(bin_file(), binmode => ':raw'), "\0");

# -o
for my $options ("-o$bin", "-o=$bin", "--output$bin", "--output=$bin") {
	unlink_testfiles($bin);
	write_file(asm_file(), "nop");

	t_z80asm_capture("-b $options ".asm_file(), "", "", 0);
	ok ! -f bin_file();
	ok -f $bin;
	t_binary(read_file($bin, binmode => ':raw'), "\0");
}

# test -o with environment variables
$ENV{TEST_ENV} = '2.bin';
unlink_testfiles($bin);
write_file(asm_file(), "nop");
t_z80asm_capture('-b -otest${TEST_ENV} '.asm_file(), "", "", 0);
ok ! -f bin_file();
ok -f $bin;
t_binary(read_file($bin, binmode => ':raw'), "\0");

delete $ENV{TEST_ENV};
unlink_testfiles($bin);
write_file(asm_file(), "nop");
t_z80asm_capture('-b -otest${TEST_ENV}2.bin '.asm_file(), "", "", 0);
ok ! -f bin_file();
ok -f $bin;
t_binary(read_file($bin, binmode => ':raw'), "\0");

unlink_testfiles($bin);

#------------------------------------------------------------------------------
# -d, --date-stamp
#------------------------------------------------------------------------------

for my $options ('-d', '--date-stamp') {
	# first compiles; second skips
	unlink_testfiles();
	write_file(asm_file(), "nop");

	t_z80asm_capture("$options ".asm_file(), "", "", 0);
	is substr(read_file(o_file(), binmode => ':raw'), -5, 5), "\0\xFF\xFF\xFF\xFF";

	my $date_obj = -M o_file();

	# now skips compile
	sleep 0.500;		# make sure our obj is older
	t_z80asm_capture("$options ".asm_file(), "", "", 0);
	is substr(read_file(o_file(), binmode => ':raw'), -5, 5), "\0\xFF\xFF\xFF\xFF";

	is -M o_file(), $date_obj;	# same object

	# touch source
	sleep 0.500;		# make sure our obj is older
	write_file(asm_file(), "nop");
	t_z80asm_capture("$options ".asm_file(), "", "", 0);
	is substr(read_file(o_file(), binmode => ':raw'), -5, 5), "\0\xFF\xFF\xFF\xFF";

	isnt -M o_file(), $date_obj;	# new object
	
	# remove source, give -d -> uses existing object - with extensiom
	unlink asm_file();
	$date_obj = -M o_file();
	t_z80asm_capture("$options ".asm_file(), "", "", 0);
	is substr(read_file(o_file(), binmode => ':raw'), -5, 5), "\0\xFF\xFF\xFF\xFF";
	is -M o_file(), $date_obj;	# new object
	
	# remove source, give -d -> uses existing object - without extensiom
	unlink asm_file();
	$date_obj = -M o_file();
	my $base = asm_file(); $base =~ s/\.\w+$//;
	t_z80asm_capture("$options $base", "", "", 0);
	is substr(read_file(o_file(), binmode => ':raw'), -5, 5), "\0\xFF\xFF\xFF\xFF";
	is -M o_file(), $date_obj;	# new object
	
}

#------------------------------------------------------------------------------
# -r, --origin
#------------------------------------------------------------------------------

# -r, --origin
for my $origin (0, 0x1234) {
	my $origin_hex = sprintf("%x", $origin);
	for my $options ("-r", "-r=", "--origin", "--origin=") {
		for my $origin_text ($origin, "0x${origin_hex}", "0X${origin_hex}", "0${origin_hex}h", "0${origin_hex}H", "\$${origin_hex}") {
			z80asm(
				options	=> "-b $options".$origin_text,
				asm		=> "start: jp start",
				bin		=> "\xC3" . pack("v", $origin),
			);
		}
	}
}

# option out of range
for my $origin (-1, 0x10000) {
	z80asm(
		options	=> "-b -r$origin",
		asm		=> "start: jp start",
		error	=> "Error: integer '$origin' out of range",
	);
}
z80asm(
	options	=> "-b -r123Z",
	asm		=> "start: jp start",
	error	=> "Error: invalid ORG option '123Z'",
);

#------------------------------------------------------------------------------
# -R, --relocatable - tested in reloc.t

#------------------------------------------------------------------------------
# --RCMX000
#------------------------------------------------------------------------------

t_z80asm_ok(0, "ex (sp),hl", "\xE3");
t_z80asm_ok(0, "ex (sp),hl", "\xED\x54", "--RCMX000");

#------------------------------------------------------------------------------
# --ti83plus
#------------------------------------------------------------------------------

t_z80asm_ok(0, "invoke 0x1234", "\xCD\x34\x12");
t_z80asm_ok(0, "invoke 0x1234", "\xEF\x34\x12", "--ti83plus");

#------------------------------------------------------------------------------
# --IXIY
#------------------------------------------------------------------------------

t_z80asm_ok(0, "ld ix,0x1234", "\xDD\x21\x34\x12");
t_z80asm_ok(0, "ld ix,0x1234", "\xFD\x21\x34\x12", "--IXIY");

t_z80asm_ok(0, "ld iy,0x1234", "\xFD\x21\x34\x12");
t_z80asm_ok(0, "ld iy,0x1234", "\xDD\x21\x34\x12", "--IXIY");

#------------------------------------------------------------------------------

# -C, --line-mode : tested in directives.t

#------------------------------------------------------------------------------
# -I, --inc-path - tested in directives.t
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# -L, --lib-path
#------------------------------------------------------------------------------

# create library
my $lib = 't/data/'.basename(lib_file());
my $lib_base = basename($lib);
my $lib_dir  = dirname($lib);

write_file(asm_file(), "PUBLIC main \n main: ret ");
t_z80asm_capture("-x".$lib." ".asm_file(), "", "", 0);
ok -f $lib;

$asm = "EXTERN main \n call main \n ret";
$bin = "\xCD\x04\x00\xC9\xC9";

# no -L, full path : OK
t_z80asm_ok(0, $asm, $bin, "-i".$lib);

# no -L, only file name : error
write_file(asm_file(), $asm);
t_z80asm_capture("-i".$lib_base." ".asm_file(), "", 
		"Error: cannot read file 'test.lib'\n".
		"1 errors occurred during assembly\n", 1);

# -L : OK
for my $options ('-L', '-L=', '--lib-path', '--lib-path=') {
	t_z80asm_ok(0, $asm, $bin, $options.$lib_dir." -i".$lib_base);
}

# use environment variable in -L
$ENV{TEST_ENV} = 'data';
t_z80asm_ok(0, $asm, $bin, '-Lt/${TEST_ENV} -i'.$lib_base);

delete $ENV{TEST_ENV};
t_z80asm_ok(0, $asm, $bin, '-Lt/da${TEST_ENV}ta -i'.$lib_base);

unlink_testfiles($lib);

#------------------------------------------------------------------------------
# -D, --define
#------------------------------------------------------------------------------

$asm = "ld a,_value23";		# BUG_0045

# no -D
t_z80asm_error($asm, "Error at file 'test.asm' line 1: symbol '_value23' not defined");

# invalid -D
for my $options ('-D23', '-Da*') {
	write_file(asm_file(), $asm);
	t_z80asm_capture("$options ".asm_file(), "", 
					"Error: illegal identifier\n".
					"1 errors occurred during assembly\n", 1);
}

# -D
for my $options ('-D', '-D=', '--define', '--define=') {
	t_z80asm_ok(0, $asm, "\x3E\x01", $options."_value23");
}

# -D with environment variables
$ENV{TEST_ENV} = 'value';
t_z80asm_ok(0, $asm, "\x3E\x01", '-D=_${TEST_ENV}23');

delete $ENV{TEST_ENV};
t_z80asm_ok(0, $asm, "\x3E\x01", '-D=_value${TEST_ENV}23');

#------------------------------------------------------------------------------
# -i, --use-lib, -x, --make-lib
#------------------------------------------------------------------------------

unlink_testfiles();

# create a lib name that is not removed by unlink_testfiles()
$lib = lib_file(); $lib =~ s/\.lib$/_lib.lib/i;
unlink $lib;

# create a library
write_file(asm_file(), "
	PUBLIC one
one: 
	ld a,1
	ret
");
for my $options ('-x', '-x=', '--make-lib', '--make-lib=') {
	unlink(o_file(), lib_file());
	t_z80asm_capture($options.lib_file()." ".asm_file(), "", "", 0);
	ok -f o_file(), o_file()." created";
	ok -f lib_file(), lib_file()." created";
}

# create $lib
ok copy(lib_file(), $lib), "create $lib";
unlink(o_file(), lib_file());

# link with the library
for my $options ('-i', '-i=', '--use-lib', '--use-lib=') {
	t_z80asm_ok(0, "
		EXTERN one
		jp one
	", "\xC3\x03\x00\x3E\x01\xC9", $options.$lib);
}

unlink_testfiles($lib);

# test BUG_0038: library modules not loaded in sequence
# obj1 requires libobj7 and obj3;
# obj2 requires libobj6 and obj3;
# obj3 requires libobj5 and obj1;
# libobj5 requires libobj6;
# libobj6 requires libobj7;
# libobj7 requires libobj5;
unlink_testfiles();
write_file(asm_file(),  "PUBLIC A1 \n EXTERN A3 \n EXTERN A7 \n A1: defb 1,A7,A3");	# A1 at addr 0, len 3
write_file(asm2_file(), "PUBLIC A2 \n EXTERN A3 \n EXTERN A6 \n A2: defb 2,A6,A3");	# A2 at addr 3, len 3
write_file(asm3_file(), "PUBLIC A3 \n EXTERN A1 \n EXTERN A5 \n A3: defb 3,A5,A1");	# A3 at addr 6, len 3

write_file(asm5_file(), "PUBLIC A5 \n EXTERN A6 \n A5: defb 5,A6");					# A5 at addr 9, len 2
write_file(asm6_file(), "PUBLIC A6 \n EXTERN A7 \n A6: defb 6,A7");					# A6 at addr 11, len 2
write_file(asm7_file(), "PUBLIC A7 \n EXTERN A5 \n A7: defb 7,A5");					# A7 at addr 13, len 2

t_z80asm_capture("-x".lib5_file()." ".asm5_file(), "", "", 0); 
ok -f lib5_file();
t_z80asm_capture("-x".lib6_file()." ".asm6_file(), "", "", 0); 
ok -f lib6_file();
t_z80asm_capture("-x".lib7_file()." ".asm7_file(), "", "", 0); 
ok -f lib7_file();

t_z80asm_capture("-l -m -b -i".lib5_file()." -i".lib6_file()." -i".lib7_file()." ".
				 asm_file()." ".asm2_file()." ".asm3_file(), "", "", 0);
ok -f bin_file();
t_binary(read_binfile(bin_file()), 
		pack("C*",
				1, 13, 6,
				2, 11, 6,
				3,  9, 0,
				5, 11, 
				6, 13,
				7,  9,
			));

unlink_testfiles();
write_file(asm_file(),  " EXTERN abs \n call abs\n");	
write_file(asm2_file(), " PUBLIC abs \nabs: ld a,1\n ret\n");

write_file(asm5_file(), " PUBLIC abs \nabs: ld a,2\n ret\n");

t_z80asm_capture("-x".lib5_file()." ".asm5_file(), "", "", 0); 
ok -f lib5_file();

t_z80asm_capture("-l -m -b -i".lib5_file()." ".asm_file()." ".asm2_file(), "", "", 0);
ok -f bin_file();
t_binary(read_binfile(bin_file()), 
		pack("C*",
				0xCD, 3, 0,
				0x3E, 1,
				0xC9
			));
unlink_testfiles();


# test BUG_0039: library not pulled in if PUBLIC symbol not referenced in expression
unlink_testfiles();

write_file(asm_file(),  "EXTERN A51 \n defb A51");

write_file(asm5_file(), "PUBLIC A5 \n PUBLIC A51 \n A5: \n defc A51 = 51");

t_z80asm_capture("-x".lib5_file()." ".asm5_file(), "", "", 0); 
ok -f lib5_file();

t_z80asm_capture("-l -m -b -i".lib5_file()." ".asm_file(), "", "", 0);
ok -f bin_file();
t_binary(read_binfile(bin_file()), pack("C*", 51 ));


# link objects and libs
# library modules are loaded in alpha-sequence of labels, starting at 10
unlink_testfiles();
write_file(asm1_file(), "PUBLIC A1 \n A1: defb 1");
write_file(asm2_file(), "PUBLIC A2 \n A2: defb 2");
write_file(asm3_file(), "PUBLIC A3 \n A3: defb 3");
t_z80asm_capture("-x".lib1_file()." ".asm1_file()." ".asm2_file()." ".asm3_file(), "", "", 0);
ok -f lib1_file();

write_file(asm4_file(), "PUBLIC A4 \n A4: defb 4");
write_file(asm5_file(), "PUBLIC A5 \n A5: defb 5");
write_file(asm6_file(), "PUBLIC A6 \n A6: defb 6");
t_z80asm_capture("-x".lib2_file()." ".asm4_file()." ".asm5_file()." ".asm6_file(), "", "", 0);
ok -f lib2_file();

write_file(asm_file(),  "A0: \n ".
						"EXTERN  A1,A2,A3,A4,A5,A6 \n EXTERN A7,A8,A9 \n ".
						"defb A1,A2,A3,A4,A5,A6,        A7,A8,A9 \n ".
						"defb 0 \n");
write_file(asm7_file(), "PUBLIC A7 \n A7: defb 7");
write_file(asm8_file(), "PUBLIC A8 \n A8: defb 8");
write_file(asm9_file(), "PUBLIC A9 \n A9: defb 9");
t_z80asm_capture("-l -b -i".lib1_file()." -i".lib2_file()." ".
				 asm_file()." ".asm7_file()." ".asm8_file()." ".asm9_file(), "", "", 0);
ok -f bin_file();
my $binary = read_file(bin_file(), binmode => ':raw', err_mode => 'quiet');
t_binary($binary, pack("C*", 
						13, 14, 15, 16, 17, 18, 10, 11, 12,
						0,
						7, 8, 9, 1, 2, 3, 4, 5, 6,
						));

# PUBLIC and EXTERN
unlink_testfiles();

write_file(asm1_file(), "
	PUBLIC func_1
	PUBLIC func_2
func_1:
	ld a,1
func_2:
	ld a,2
	ret
");

write_file(asm2_file(), "
	EXTERN  func_2
	call func_2
	ret
");

# link object files
t_z80asm_capture("-b ".asm2_file()." ".asm1_file(), "", "", 0);
t_binary(read_binfile(bin2_file()), "\xCD\x06\x00\xC9\x3E\x01\x3E\x02\xC9");

# link library files
t_z80asm_capture("-x".lib1_file()." ".asm1_file(), "", "", 0);
t_z80asm_capture("-b -i".lib1_file()." ".asm2_file(), "", "", 0);
t_binary(read_binfile(bin2_file()), "\xCD\x06\x00\xC9\x3E\x01\x3E\x02\xC9");

#------------------------------------------------------------------------------
# --split-bin, ORG -1: tested in directives.t

#------------------------------------------------------------------------------
# --cpu=z180
t_z80asm_ok(0, "
	slp
	
	mlt bc
	mlt de
	mlt hl
	mlt sp
	
	in0 b,(10)
	in0 c,(11)
	in0 d,(12)
	in0 e,(13)
	in0 h,(14)
	in0 l,(15)
	in0 f,(16)
	in0 a,(17)
	
	out0 (10),b
	out0 (11),c
	out0 (12),d
	out0 (13),e
	out0 (14),h
	out0 (15),l
	out0 (16),f
	out0 (17),a
	
	otim
	otimr
	otdm
	otdmr
	
	tstio 23
	
	tst a,b
	tst a,c
	tst a,d
	tst a,e
	tst a,h
	tst a,l
	tst a,(hl)
	tst a,a
	tst a,23
	
	tst b
	tst c
	tst d
	tst e
	tst h
	tst l
	tst (hl)
	tst a
	tst 23
	
", pack("C*", 
	0xED, 0x76,		# slp
	
	0xED, 0x4C, 	# mlt
	0xED, 0x5C, 
	0xED, 0x6C, 
	0xED, 0x7C, 
	
	0xED, 0x00, 10,	# in0
	0xED, 0x08, 11,	
	0xED, 0x10, 12,	
	0xED, 0x18, 13,	
	0xED, 0x20, 14,	
	0xED, 0x28, 15,	
	0xED, 0x30, 16,	
	0xED, 0x38, 17,	
	
	0xED, 0x01, 10,	# out0
	0xED, 0x09, 11,	
	0xED, 0x11, 12,	
	0xED, 0x19, 13,	
	0xED, 0x21, 14,	
	0xED, 0x29, 15,	
	0xED, 0x31, 16,	
	0xED, 0x39, 17,	
	
	0xED, 0x83,		# otxx
	0xED, 0x93,		
	0xED, 0x8B,		
	0xED, 0x9B,		
	
	0xED, 0x74, 23,	# tstio
	
	0xED, 0x04,		# tst
	0xED, 0x0C,
	0xED, 0x14,
	0xED, 0x1C,
	0xED, 0x24,
	0xED, 0x2C,
	0xED, 0x34,
	0xED, 0x3C,
	0xED, 0x64, 23, 
	
	0xED, 0x04,		# tst
	0xED, 0x0C,
	0xED, 0x14,
	0xED, 0x1C,
	0xED, 0x24,
	0xED, 0x2C,
	0xED, 0x34,
	0xED, 0x3C,
	0xED, 0x64, 23, 
	
	
), "--cpu=z180");

t_z80asm_error("slp			", "Error at file 'test.asm' line 1: illegal identifier");
t_z80asm_error("mlt bc		", "Error at file 'test.asm' line 1: illegal identifier");
t_z80asm_error("in0 b,(10)	", "Error at file 'test.asm' line 1: illegal identifier");
t_z80asm_error("out0 (10),b	", "Error at file 'test.asm' line 1: illegal identifier");
t_z80asm_error("otim		", "Error at file 'test.asm' line 1: illegal identifier");
t_z80asm_error("otimr		", "Error at file 'test.asm' line 1: illegal identifier");
t_z80asm_error("otdm		", "Error at file 'test.asm' line 1: illegal identifier");
t_z80asm_error("otdmr		", "Error at file 'test.asm' line 1: illegal identifier");
t_z80asm_error("tstio 23	", "Error at file 'test.asm' line 1: illegal identifier");
t_z80asm_error("tst b		", "Error at file 'test.asm' line 1: illegal identifier");


unlink_testfiles();
done_testing();
