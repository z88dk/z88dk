#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2015
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Test options

use strict;
use warnings;
use File::Slurp;
use File::Basename;
use File::Copy;
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
write_file(asm1_file(), "defb 1");
write_file(asm2_file(), "defb 2");
write_file(asm3_file(), "defb 3");
write_file(asm4_file(), "defb 4");
t_z80asm_capture(join(" ", "-r0", "-b", asm1_file(), asm2_file(), asm3_file(), asm4_file()),
				 "", "", 0);
t_binary(read_binfile(bin1_file()), "\1\2\3\4");
ok unlink bin1_file();

write_binfile(asmlst1_file(), "\r\r\n\n  ".asm2_file()."  \r\r\n\n  \@ ".asmlst2_file());
write_binfile(asmlst2_file(), "\r\r\n\n  ".asm3_file()."  \r\r\n\n    ".asm4_file()."\n");
t_z80asm_capture(join(" ", "-r0", "-b", asm1_file(), '@'.asmlst1_file()),
				 "", "", 0);
t_binary(read_binfile(bin1_file()), "\1\2\3\4");
ok unlink bin1_file();

write_binfile(asmlst1_file(), "\r\r\n\n  ".asm2_file()."  \r\r\n\n  \@ ".asmlst2_file());
write_binfile(asmlst2_file(), "\r\r\n\n  ".asm2_file()."  \r\r\n\n  \@ ".asmlst1_file());
t_z80asm_capture(join(" ", "-r0", "-b", asm1_file(), '@'.asmlst1_file()),
				 "", <<'ERR', 1);
Error at file 'test2.asmlst' line 7: cannot include file 'test1.asmlst' recursively
1 errors occurred during assembly
ERR

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
    .asm = source file (default), or alternative -e<ext>
    .obj = object file (default), or alternative -M<ext>
    .lst = list file
    .bin = Z80 binary file
    .sym = symbols file
    .map = map file
    .reloc = reloc file
    .def = global address definition file
    .err = error file

Help Options:
  -h, --help             Show help options
  -v, --verbose          Be verbose
* -nv, --not-verbose     Don't be verbose

Input / Output File Options:
  -e, --asm-ext=EXT      Assembly file extension excluding '.'
  -M, --obj-ext=EXT      Object file extension excluding '.'
  -o, --output=FILE      Output binary file

Code Generation Options:
  --RCMX000              Assemble for RCM2000/RCM3000 series of Z80-like CPU
  --sdcc                 Assemble for Small Device C Compiler
  -plus, --ti83plus      Interpret 'Invoke' as RST 28h
  -IXIY, --swap-ix-iy    Swap IX and IY registers
  -C, --line-mode        Enable LINE directive

Environment:
  -I, --inc-path=PATH    Add directory to include search path
  -L, --lib-path=PATH    Add directory to library search path
  -D, --define=SYMBOL    Define a static symbol

Libraries:
  -x, --make-lib=[FILE]  Create a library file.lib
  -i, --use-lib=[FILE]   Link library file.lib

Binary Output:
  -b, --make-bin         Assemble and link/relocate to file.bin
* -nb, --no-make-bin     No binary file
  --split-bin            Create one binary file per section
  -d, --date-stamp       Assemble only updated files
* -nd, --no-date-stamp   Assemble all files
  -a, --make-updated-bin Assemble updated files and link/relocate to file.bin
  -r, --origin=ORG_HEX   Relocate binary file to given address
  -R, --relocatable      Create relocatable code

Output File Options:
* -s, --symtable         Create symbol table file.sym
  -ns, --no-symtable     No symbol table file
  -l, --list             Create listing file.lst
* -nl, --no-list         No listing file
* -m, --map              Create address map file.map
  -nm, --no-map          No address map file
  -g, --globaldef        Create global definition file.def
* -ng, --no-globaldef    No global definition file
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
Create symbol table file.sym
Create listing file.lst
Create global definition file.def
Assemble and link/relocate to file.bin
Create address map file.map

Assembling 'test.asm'...
Pass1...
Reading 'test.asm'...
Pass2...
Size of module 'test' is 3 bytes

linking module(s)...
Pass1...
Code size of linked modules is 3 bytes ($0000 to $0002)
Pass2...
Creating map...
Creating global definition file...
Code generation completed.
END

for my $options ('-v', '--verbose') {
	unlink_testfiles();
	write_file(asm_file(), " nop \n nop \n nop");
	t_z80asm_capture("-r0 -a -s -l -g $options ".asm_file(), 
					"Assemble only updated files\n".$verbose_text, "", 0);
	ok -f obj_file();
	ok -f bin_file();
	is read_file(bin_file(), binmode => ':raw'), "\0\0\0";
	
	unlink_testfiles();
	write_file(asm_file(), " nop \n nop \n nop");
	t_z80asm_capture("-r0 -b -s -l -g $options ".asm_file(), 
					"Assemble all files\n".$verbose_text, "", 0);
	ok -f obj_file();
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

#------------------------------------------------------------------------------
# --not-verbose, -nv
#------------------------------------------------------------------------------
unlink_testfiles();
write_file(asm_file(), "nop");

for my $options ('-nv', '--not-verbose') {
	t_z80asm_capture("-r0 -b $options ".asm_file(), "", "", 0);
	ok -f obj_file();
	ok -f bin_file();
	is read_file(bin_file(), binmode => ':raw'), "\0";
}

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
# --asm-ext=EXT, -eEXT
#------------------------------------------------------------------------------
my $base = asm_file(); $base =~ s/\.\w+$//;

unlink_testfiles();
write_file(asm_file(), "ret");
t_z80asm_capture("-r0 -b ".$base, "", "", 0);
is read_file(bin_file(), binary => ':raw'), "\xC9", "assemble ok";

for my $options ('-exxx', '-e=xxx', '--asm-extxxx', '--asm-ext=xxx') {
	unlink_testfiles();
	write_file($base.".xxx", "ret");
	t_z80asm_capture("-r0 -b $options $base", "", "", 0);
	is read_file(bin_file(), binary => ':raw'), "\xC9", "assemble ok";
}

unlink_testfiles($base.".xxx");

# check no arguments
t_z80asm_capture("-e", 	"", 	<<'ERR', 1);
Error: illegal option '-e'
Error: source filename missing
2 errors occurred during assembly
ERR

t_z80asm_capture("--asm-ext", 	"", 	<<'ERR', 1);
Error: illegal option '--asm-ext'
Error: source filename missing
2 errors occurred during assembly
ERR

#------------------------------------------------------------------------------
# --obj-ext=EXT, -MEXT
#------------------------------------------------------------------------------
$base = asm_file(); $base =~ s/\.\w+$//;

unlink_testfiles();
write_file(asm_file(), "ret");
t_z80asm_capture($base, "", "", 0);
like read_file(obj_file(), binary => ':raw'), qr/\xC9\xFF\xFF\xFF\xFF\z/, "assemble ok";

for my $options ('-Mo', '-M=o', '--obj-exto', '--obj-ext=o') {
	unlink_testfiles();
	write_file(asm_file(), "ret");
	t_z80asm_capture("$options $base", "", "", 0);
	like read_file($base.".o", binary => ':raw'), qr/\xC9\xFF\xFF\xFF\xFF\z/, "assemble ok";
}

unlink_testfiles($base.".o");

# check no arguments
t_z80asm_capture("-M", 	"", 	<<'ERR', 1);
Error: illegal option '-M'
Error: source filename missing
2 errors occurred during assembly
ERR

t_z80asm_capture("--obj-ext", 	"", 	<<'ERR', 1);
Error: illegal option '--obj-ext'
Error: source filename missing
2 errors occurred during assembly
ERR

#------------------------------------------------------------------------------
# -sdcc
#------------------------------------------------------------------------------
unlink_testfiles();
t_z80asm_error("defc main = 0x1234\ncall _main", 
		"Error at file 'test.asm' line 2: symbol '_main' not defined");
for my $options ('-sdcc', '--sdcc') {
	t_z80asm(
		options	=> $options,
		asm		=> "defc main = 0x1234\ncall _main",
		bin		=> "\xCD\x34\x12", 
		err		=> "Warning at file 'test.asm' line 2: symbol 'main' used as '_main'",
	);
}

#------------------------------------------------------------------------------
# -s, --symtable, -ns, --no-symtable, -l, --list, -nl, --no-list
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

# no symbol table, no list
for my $options ('-nl -ns', '-nl --no-symtable') {
	t_z80asm(
		asm		=> $asm,
		bin		=> $bin,
		options	=> $options,
		nolist	=> 1,
	);
}

# list file implies no symbol table
for my $options ('-l', '-l -s', '-l --symtable') {
	t_z80asm(
		asm		=> $asm,
		bin		=> $bin,
		options	=> $options,
		nolist	=> 1,
	);
}

# no list file implies symbol table
for my $options ('', '-nl', '-s', '--symtable', '-nl -s', '-nl --symtable') {
	t_z80asm(
		asm		=> $asm,
		bin		=> $bin,
		options	=> $options,
		nolist	=> 1,
	);
}

#------------------------------------------------------------------------------
# -m, --map, -nm, --no-map
#------------------------------------------------------------------------------
note "BUG_0036";
$asm = "
	define not_shown
	defc zero=0
	PUBLIC main
main: ld b,10
loop: djnz loop
x31_x31_x31_x31_x31_x31_x31_x31: defb zero
x_32_x32_x32_x32_x32_x32_x32_x32: defb zero
";
my $asm2 = "
	define not_shown
	PUBLIC func
func: ld b,10
loop: djnz loop
	  ret
";
$bin = "\x06\x0A\x10\xFE\x00\x00\x06\x0A\x10\xFE\xC9";


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
ASMHEAD                         = 0000, G: 
ASMSIZE                         = 000B, G: 
ASMTAIL                         = 000B, G: 


ASMHEAD                         = 0000, G: 
ASMSIZE                         = 000B, G: 
ASMTAIL                         = 000B, G: 
END
}

# -m
for my $options ('-m', '--map') {
	t_z80asm(
		asm		=> $asm,
		asm2	=> $asm2,
		bin		=> $bin,
		options	=> $options,
	);
	ok -f map_file(), map_file();
	eq_or_diff scalar(read_file(map_file())), <<'END', "mapfile contents";
ASMHEAD                         = 0000, G: 
ASMSIZE                         = 000B, G: 
ASMTAIL                         = 000B, G: 
func                            = 0006, G: test2
loop                            = 0002, L: test
loop                            = 0008, L: test2
main                            = 0000, G: test
x31_x31_x31_x31_x31_x31_x31_x31 = 0004, L: test
x_32_x32_x32_x32_x32_x32_x32_x32 = 0005, L: test
zero                            = 0000, L: test


ASMHEAD                         = 0000, G: 
main                            = 0000, G: test
zero                            = 0000, L: test
loop                            = 0002, L: test
x31_x31_x31_x31_x31_x31_x31_x31 = 0004, L: test
x_32_x32_x32_x32_x32_x32_x32_x32 = 0005, L: test
func                            = 0006, G: test2
loop                            = 0008, L: test2
ASMSIZE                         = 000B, G: 
ASMTAIL                         = 000B, G: 
END
}

# -nm
for my $options ('-m -nm', '--map --no-map') {
	t_z80asm(
		asm		=> $asm,
		asm2	=> $asm2,
		bin		=> $bin,
		options	=> $options,
	);
	ok ! -f map_file(), "no ".map_file();
}

#------------------------------------------------------------------------------
# -g, --globaldef, -ng, --no-globaldef
#------------------------------------------------------------------------------
$asm = "
	PUBLIC main, x31_x31_x31_x31_x31_x31_x31_x31, x_32_x32_x32_x32_x32_x32_x32_x32
main: ld b,10
loop: djnz loop
x31_x31_x31_x31_x31_x31_x31_x31: defb 0
x_32_x32_x32_x32_x32_x32_x32_x32: defb 0
";
$asm2 = "
	PUBLIC func
func: ret
";
$bin = "\x06\x0A\x10\xFE\x00\x00\xC9";

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
DEFC main                            = $0000 ; Module test
DEFC x31_x31_x31_x31_x31_x31_x31_x31 = $0004 ; Module test
DEFC x_32_x32_x32_x32_x32_x32_x32_x32 = $0005 ; Module test
DEFC func                            = $0006 ; Module test2
END
}

# -ng
for my $options ('-g -ng', '--globaldef --no-globaldef') {
	t_z80asm(
		asm		=> $asm,
		asm2	=> $asm2,
		bin		=> $bin,
		options	=> $options,
	);
	ok ! -f def_file(), "no ".def_file();
}

#------------------------------------------------------------------------------
# -b, --make-bin, -nb, --no-make-bin
#------------------------------------------------------------------------------

# -b
for my $options ('-b', '--make-bin') {
	unlink_testfiles();
	write_file(asm_file(), "nop");

	t_z80asm_capture("-r0 $options ".asm_file(), "", "", 0);
	ok -f obj_file();
	ok -f bin_file();
	ok -f map_file();
	is read_file(bin_file(), binmode => ':raw'), "\0";
}

# -nb
for my $options ('-b -nb', '--make-bin --no-make-bin') {
	unlink_testfiles();
	write_file(asm_file(), "nop");

	t_z80asm_capture("$options ".asm_file(), "", "", 0);
	ok -f obj_file();
	ok ! -f map_file();
	ok ! -f bin_file();
}

#------------------------------------------------------------------------------
# -o, --output
#------------------------------------------------------------------------------
$bin = bin_file(); $bin =~ s/\.bin$/2.bin/i;

# no -o
unlink_testfiles($bin);
write_file(asm_file(), "nop");

t_z80asm_capture("-r0 -b ".asm_file(), "", "", 0);
ok -f bin_file();
ok ! -f $bin;
t_binary(read_file(bin_file(), binmode => ':raw'), "\0");

# -o
for my $options ("-o$bin", "-o=$bin", "--output$bin", "--output=$bin") {
	unlink_testfiles($bin);
	write_file(asm_file(), "nop");

	t_z80asm_capture("-r0 -b $options ".asm_file(), "", "", 0);
	ok ! -f bin_file();
	ok -f $bin;
	t_binary(read_file($bin, binmode => ':raw'), "\0");
}

unlink_testfiles($bin);

#------------------------------------------------------------------------------
# -d, --date-stamp
#------------------------------------------------------------------------------

for my $options ('-d', '--date-stamp') {
	# first compiles; second skips
	unlink_testfiles();
	write_file(asm_file(), "nop");

	t_z80asm_capture("$options ".asm_file(), "", "", 0);
	is substr(read_file(obj_file(), binmode => ':raw'), -5, 5), "\0\xFF\xFF\xFF\xFF";

	my $date_obj = -M obj_file();

	# now skips compile
	sleep 1;		# make sure our obj is older
	t_z80asm_capture("$options ".asm_file(), "", "", 0);
	is substr(read_file(obj_file(), binmode => ':raw'), -5, 5), "\0\xFF\xFF\xFF\xFF";

	is -M obj_file(), $date_obj;	# same object

	# touch source
	sleep 1;		# make sure our obj is older
	write_file(asm_file(), "nop");
	t_z80asm_capture("$options ".asm_file(), "", "", 0);
	is substr(read_file(obj_file(), binmode => ':raw'), -5, 5), "\0\xFF\xFF\xFF\xFF";

	isnt -M obj_file(), $date_obj;	# new object

	$date_obj = -M obj_file();

	# compile again
	for my $options2 ('-nd', '--no-date-stamp') {
		sleep 1;		# make sure our obj is older
		t_z80asm_capture("$options $options2 ".asm_file(), "", "", 0);
		is substr(read_file(obj_file(), binmode => ':raw'), -5, 5), "\0\xFF\xFF\xFF\xFF";

		isnt -M obj_file(), $date_obj;	# new object
	}
}

#------------------------------------------------------------------------------
# -a, --make-updated-bin
#------------------------------------------------------------------------------

for my $options ('-a', '--make-updated-bin') {
	# first compiles; second skips
	unlink_testfiles();
	write_file(asm_file(), "nop");

	t_z80asm_capture("-r0 $options ".asm_file(), "", "", 0);
	is read_file(bin_file(), binmode => ':raw'), "\0";

	my $date_obj = -M obj_file();

	# now skips compile
	sleep 1;		# make sure our obj is older
	t_z80asm_capture("-r0 $options ".asm_file(), "", "", 0);
	is read_file(bin_file(), binmode => ':raw'), "\0";

	is -M obj_file(), $date_obj;	# same object

	# touch source
	sleep 1;		# make sure our obj is older
	write_file(asm_file(), "nop");
	t_z80asm_capture("-r0 $options ".asm_file(), "", "", 0);
	is read_file(bin_file(), binmode => ':raw'), "\0";

	isnt -M obj_file(), $date_obj;	# new object
}

#------------------------------------------------------------------------------
# -r, --origin
#------------------------------------------------------------------------------

for my $org ('0', '100') {
	for my $options ("-r", "-r=", "--origin", "--origin=") {
		unlink_testfiles();
		write_file(asm_file(), "start: jp start");

		t_z80asm_capture("$options$org -b ".asm_file(), "", "", 0);
		t_binary(read_file(bin_file(), binmode => ':raw'), "\xC3".pack("v", oct('0x'.$org)));
	}
}

for (['-1', '-1'], ['10000', '65536']) {
	my($org_h, $org_d) = @$_;
	
	unlink_testfiles();
	write_file(asm_file(), "nop");
	t_z80asm_capture("--make-bin --origin=$org_h ".asm_file(), "", <<"ERR", 1);
Error: integer '$org_d' out of range
1 errors occurred during assembly
ERR
	ok ! -f obj_file();
	ok ! -f bin_file();
}

#------------------------------------------------------------------------------
# -R, --relocatable - tested in reloc.t

#------------------------------------------------------------------------------
# --RCMX000
#------------------------------------------------------------------------------

t_z80asm_ok(0, "ex (sp),hl", "\xE3");
t_z80asm_ok(0, "ex (sp),hl", "\xED\x54", "-RCMX000");
t_z80asm_ok(0, "ex (sp),hl", "\xED\x54", "--RCMX000");

#------------------------------------------------------------------------------
# -plus, --ti83plus
#------------------------------------------------------------------------------

t_z80asm_ok(0, "invoke 0x1234", "\xCD\x34\x12");
t_z80asm_ok(0, "invoke 0x1234", "\xEF\x34\x12", "-plus");
t_z80asm_ok(0, "invoke 0x1234", "\xEF\x34\x12", "--ti83plus");

#------------------------------------------------------------------------------
# -IXIY, --swap-ix-iy
#------------------------------------------------------------------------------

t_z80asm_ok(0, "ld ix,0x1234", "\xDD\x21\x34\x12");
t_z80asm_ok(0, "ld ix,0x1234", "\xFD\x21\x34\x12", "-IXIY");
t_z80asm_ok(0, "ld ix,0x1234", "\xFD\x21\x34\x12", "--swap-ix-iy");

t_z80asm_ok(0, "ld iy,0x1234", "\xFD\x21\x34\x12");
t_z80asm_ok(0, "ld iy,0x1234", "\xDD\x21\x34\x12", "-IXIY");
t_z80asm_ok(0, "ld iy,0x1234", "\xDD\x21\x34\x12", "--swap-ix-iy");

#------------------------------------------------------------------------------

# -C, --line-mode : tested in directives.t

#------------------------------------------------------------------------------
# -t (deprecated)
#------------------------------------------------------------------------------

$asm = "
	PUBLIC main
main:	ld b,10
loop:	djnz loop
	ret
";
$bin = "\x06\x0A\x10\xFE\xC9";
my $map = <<'END';
ASMHEAD                         = 0000, G: 
ASMSIZE                         = 0005, G: 
ASMTAIL                         = 0005, G: 
loop                            = 0002, L: test
main                            = 0000, G: test


ASMHEAD                         = 0000, G: 
main                            = 0000, G: test
loop                            = 0002, L: test
ASMSIZE                         = 0005, G: 
ASMTAIL                         = 0005, G: 
END


# no -t
t_z80asm(
	asm		=> $asm,
	bin		=> $bin,
	options	=> '-m',
);
ok -f map_file(), map_file();
eq_or_diff scalar(read_file(map_file())), $map, "mapfile contents";


# -t4
t_z80asm(
	asm		=> $asm,
	bin		=> $bin,
	options	=> '-m -t4',
	err		=> "Warning: option '-t' is deprecated",
);
ok -f map_file(), map_file();
eq_or_diff scalar(read_file(map_file())), $map, "mapfile contents";

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

#------------------------------------------------------------------------------
# -i, --use-lib, -x, --make-lib
#------------------------------------------------------------------------------

unlink_testfiles();

# create a lib name that is not removed by unlink_testfiles()
$lib = lib_file(); $lib =~ s/\.lib$/_lib.lib/i;
unlink $lib;

# create a library without Z80_STDLIB
delete $ENV{Z80_STDLIB};
write_file(asm_file(), "
	PUBLIC one
one: 
	ld a,1
	ret
");
for my $options ('-x', '-x=', '--make-lib', '--make-lib=') {
	t_z80asm_capture($options.lib_file()." ".asm_file(), "", "", 0);
	ok -f obj_file(), obj_file()." created";
	ok -f lib_file(), lib_file()." created";
	is unlink(obj_file(), lib_file()), 2, "delete old obj and lib";
}

# create the same library with Z80_STDLIB
$ENV{Z80_STDLIB} = lib_file();
for my $options ('-x', '-x=', '--make-lib', '--make-lib=') {
	t_z80asm_capture($options." ".asm_file(), "", "", 0);
	ok -f obj_file(), obj_file()." created";
	ok -f lib_file(), lib_file()." created";
}

# create $lib
ok copy(lib_file(), $lib), "create $lib";

# link with the library without Z80_STDLIB
delete $ENV{Z80_STDLIB};
for my $options ('-i', '-i=', '--use-lib', '--use-lib=') {
	t_z80asm_ok(0, "
		EXTERN one
		jp one
	", "\xC3\x03\x00\x3E\x01\xC9", $options.$lib);
}

# link with the library with Z80_STDLIB
# cause the buffer overrun, detected in MSVC debug version
$ENV{Z80_STDLIB} = $lib;
for my $options ('-i', '-i=', '--use-lib', '--use-lib=') {
	t_z80asm_ok(0, "
		EXTERN one
		jp one
	", "\xC3\x03\x00\x3E\x01\xC9", $options);
}

unlink_testfiles($lib);

SKIP: { skip "BUG_0038";

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

t_z80asm_capture("-l -m -b -r0 -i".lib5_file()." -i".lib6_file()." -i".lib7_file()." ".
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

};

# test BUG_0039: library not pulled in if PUBLIC symbol not referenced in expression
unlink_testfiles();

write_file(asm_file(),  "EXTERN A51 \n defb A51");

write_file(asm5_file(), "PUBLIC A5 \n PUBLIC A51 \n A5: \n defc A51 = 51");

t_z80asm_capture("-x".lib5_file()." ".asm5_file(), "", "", 0); 
ok -f lib5_file();

t_z80asm_capture("-l -m -b -r0 -i".lib5_file()." ".asm_file(), "", "", 0);
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
t_z80asm_capture("-l -b -r0 -i".lib1_file()." -i".lib2_file()." ".
				 asm_file()." ".asm7_file()." ".asm8_file()." ".asm9_file(), "", "", 0);
ok -f bin_file();
my $binary = read_file(bin_file(), binmode => ':raw', err_mode => 'quiet');
t_binary($binary, pack("C*", 
						13, 14, 15, 16, 17, 18, 10, 11, 12,
						0,
						7, 8, 9, 1, 2, 3, 4, 5, 6,
						));

# PUBLIC and EXTERN, without -sdcc
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
t_z80asm_capture("-r0 -b ".asm2_file()." ".asm1_file(), "", "", 0);
t_binary(read_binfile(bin2_file()), "\xCD\x06\x00\xC9\x3E\x01\x3E\x02\xC9");

# link library files
t_z80asm_capture("-x".lib1_file()." ".asm1_file(), "", "", 0);
t_z80asm_capture("-r0 -b -i".lib1_file()." ".asm2_file(), "", "", 0);
t_binary(read_binfile(bin2_file()), "\xCD\x06\x00\xC9\x3E\x01\x3E\x02\xC9");


# PUBLIC and EXTERN, with -sdcc
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
	EXTERN func_2
	call func_2
	ret
");

# link object files
t_z80asm_capture("-r0 -b ".asm2_file()." ".asm1_file(), "", "", 0);
t_binary(read_binfile(bin2_file()), "\xCD\x06\x00\xC9\x3E\x01\x3E\x02\xC9");

# link library files
t_z80asm_capture("-x".lib1_file()." ".asm1_file(), "", "", 0);
t_z80asm_capture("-sdcc -r0 -b -i".lib1_file()." ".asm2_file(), "", "", 0);
t_binary(read_binfile(bin2_file()), "\xCD\x06\x00\xC9\x3E\x01\x3E\x02\xC9");

#------------------------------------------------------------------------------
# --split-bin, ORG -1: tested in directives.t


unlink_testfiles();
done_testing();
