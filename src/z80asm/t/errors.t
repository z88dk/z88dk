#!/usr/bin/perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2020
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#
# Test error messages

use Modern::Perl;
use Test::More;
use File::Copy;
use Time::HiRes 'sleep';
use File::Path qw(make_path remove_tree);;
use Capture::Tiny::Extended 'capture';
use Test::Differences;
use Path::Tiny;
require './t/test_utils.pl';

#------------------------------------------------------------------------------
# Black box tests
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# error_expression
unlink_testfiles();
write_binfile(o_file(), objfile( NAME => "test",
								   CODE => [["", -1, 1, "\0\0"]],
								   EXPR => [ ["C", "test.asm",1, "", 0, 0, "", "*+VAL"] ] ));
t_z80asm_capture("-b -d ".o_file(),
				 "",
				 "Error at file 'test.asm' line 1: syntax error in expression\n",
				 1);

#------------------------------------------------------------------------------
# warn_int_range / error_int_range on pass2 and multi-module assembly
unlink_testfiles();

write_file(asm_file(), <<'ASM');
	extern G_129, G_128, G0, G127, G128, G255, G256

; Byte = -129
	ld	a, L_129
	ld	a, G_129
	ld	a, G0 - 129

; Byte = -128
	ld	a, L_128
	ld	a, G_128
	ld	a, G0 - 128

; Byte = 255
	ld	a, L255
	ld	a, G255
	ld	a, G0 + 255

; Byte = 256
	ld	a, L256
	ld	a, G256
	ld	a, G0 + 256

; SignedByte = -129
	ld	(ix + L_129), -1
	ld	(ix + G_129), -1
	ld	(ix + G0 -129), -1

; SignedByte = -128
	ld	(ix + L_128), -1
	ld	(ix + G_128), -1
	ld	(ix + G0 -128), -1

; SignedByte = 127
	ld	(ix + L127), -1
	ld	(ix + G127), -1
	ld	(ix + G0 + 127), -1

; SignedByte = 128
	ld	(ix + L128), -1
	ld	(ix + G128), -1
	ld	(ix + G0 + 128), -1

; Local variables
	defc L_129   = -129
	defc L_128   = -128
	defc L255    =  255
	defc L256    =  256
	defc L127    =  127
	defc L128    =  128
ASM

write_file(asm1_file(), <<'ASM1');

; Global variables
	public G_129, G_128, G0, G127, G128, G255, G256
	defc G_129   = -129
	defc G_128   = -128
	defc G0      =  0
	defc G127    =  127
	defc G128    =  128
	defc G255    =  255
	defc G256    =  256
ASM1

t_z80asm_capture("-b ".asm_file()." ".asm1_file(), "", <<'ERR', 0);
Warning at file 'test.asm' line 4: integer '-129' out of range
Warning at file 'test.asm' line 19: integer '256' out of range
Warning at file 'test.asm' line 24: integer '-129' out of range
Warning at file 'test.asm' line 39: integer '128' out of range
Warning at file 'test.asm' line 5: integer '-129' out of range
Warning at file 'test.asm' line 6: integer '-129' out of range
Warning at file 'test.asm' line 20: integer '256' out of range
Warning at file 'test.asm' line 21: integer '256' out of range
Warning at file 'test.asm' line 25: integer '-129' out of range
Warning at file 'test.asm' line 26: integer '-129' out of range
Warning at file 'test.asm' line 40: integer '128' out of range
Warning at file 'test.asm' line 41: integer '128' out of range
ERR

t_binary(read_binfile(bin_file()), pack("C*",
		0x3E, 0x7F,
		0x3E, 0x7F,
		0x3E, 0x7F,
		0x3E, 0x80,
		0x3E, 0x80,
		0x3E, 0x80,
		0x3E, 0xFF,
		0x3E, 0xFF,
		0x3E, 0xFF,
		0x3E, 0x00,
		0x3E, 0x00,
		0x3E, 0x00,
		0xDD, 0x36, 0x7F, 0xFF,
		0xDD, 0x36, 0x7F, 0xFF,
		0xDD, 0x36, 0x7F, 0xFF,
		0xDD, 0x36, 0x80, 0xFF,
		0xDD, 0x36, 0x80, 0xFF,
		0xDD, 0x36, 0x80, 0xFF,
		0xDD, 0x36, 0x7F, 0xFF,
		0xDD, 0x36, 0x7F, 0xFF,
		0xDD, 0x36, 0x7F, 0xFF,
		0xDD, 0x36, 0x80, 0xFF,
		0xDD, 0x36, 0x80, 0xFF,
		0xDD, 0x36, 0x80, 0xFF,
));

# defvar out of range - tested in directives.t
# org out of range - tested in directives.t

# JR / DJNZ
for ([jr => chr(0x18)], [djnz => chr(0x10)])
{
	my($jump, $opcode) = @$_;

	t_z80asm(
		asm		=> "$jump ASMPC+2-129",
		err		=> "Error at file 'test.asm' line 1: integer '-129' out of range",
	);

	t_z80asm(
		asm		=> "$jump label : defc label = ASMPC-129",
		linkerr	=> "Error at file 'test.asm' line 1: integer '-129' out of range",
	);

	t_z80asm(
		asm		=> "$jump ASMPC+2+128",
		err		=> "Error at file 'test.asm' line 1: integer '128' out of range",
	);

	t_z80asm(
		asm		=> "$jump label : defc label = ASMPC+128",
		linkerr	=> "Error at file 'test.asm' line 1: integer '128' out of range",
	);

	for my $org (0, 0x8000, 0xFFFE) {
		t_z80asm(
			org		=> $org,
			asm		=> "$jump ASMPC+2-128",
			bin		=> "$opcode\x80",
		);

		t_z80asm(
			org		=> $org,
			asm		=> "$jump label : defc label = ASMPC-128",
			bin		=> "$opcode\x80",
		);

		t_z80asm(
			org		=> $org,
			asm		=> "$jump ASMPC+2+127",
			bin		=> "$opcode\x7F",
		);

		t_z80asm(
			org		=> $org,
			asm		=> "$jump label : defc label = ASMPC+127",
			bin		=> "$opcode\x7F",
		);

	}
}

#------------------------------------------------------------------------------
# error_unbanlanced_paren
unlink_testfiles();
t_z80asm_ok(0, "ld a,2*(1+2)", "\x3E\x06");
t_z80asm_ok(0, "ld a,2*[1+2]", "\x3E\x06");
t_z80asm_error("ld a,2*(1+2", 	"Error at file 'test.asm' line 1: syntax error in expression");
t_z80asm_error("ld a,2*(1+2]", 	"Error at file 'test.asm' line 1: syntax error in expression");
t_z80asm_error("ld a,2*[1+2", 	"Error at file 'test.asm' line 1: syntax error in expression");
t_z80asm_error("ld a,2*[1+2)", 	"Error at file 'test.asm' line 1: syntax error in expression");

#------------------------------------------------------------------------------
# error_not_defined
unlink_testfiles();
t_z80asm_error("ld a,NOSYMBOL", "Error at file 'test.asm' line 1: symbol 'NOSYMBOL' not defined");

#------------------------------------------------------------------------------
# error_not_defined_expr
my $lib = lib_file(); $lib =~ s/\.lib$/2.lib/i;
unlink_testfiles($lib);
write_file(asm_file(), "main: ret");
t_z80asm_capture("-x".$lib." ".asm_file(), "", "", 0);
ok -f $lib;
write_file(asm_file(), "EXTERN main \n call main");
t_z80asm_capture("-b -l".$lib." ".asm_file(), "",
		"Error at file 'test.asm' line 2: symbol 'main' not defined\n",
		1);

#------------------------------------------------------------------------------
# error_no_src_file
unlink_testfiles();
t_z80asm_capture("-b", "",
		"Error: source file missing\n", 1);

#------------------------------------------------------------------------------
# error_illegal_option
unlink_testfiles();
write_file(asm_file(), "");
t_z80asm_capture("-Zillegaloption ".asm_file(), "",
		"Error: illegal option: -Zillegaloption\n",
		1);
t_z80asm_capture("+Zillegaloption ".asm_file(), "",
		"Error: illegal option: +Zillegaloption\n",
		1);

#------------------------------------------------------------------------------
# fatal_max_codesize
unlink_testfiles();

# DEFM
t_z80asm_ok(0, "defs 65535, 'a' \n defm \"a\" \n",
	    "a" x 65536);
t_z80asm_error("defs 65536, 'a' \n defm \"a\" \n",
	       "Error at file 'test.asm' line 2: max. code size of 65536 bytes reached");

t_z80asm_ok(0, "defs 65534, 'a' \n defm \"aa\" \n",
	    "a" x 65536);
t_z80asm_error("defs 65535, 'a' \n defm \"aa\" \n",
	       "Error at file 'test.asm' line 2: max. code size of 65536 bytes reached");

t_z80asm_ok(0, "defs 65534, 'a' \n defm 97, \"a\" \n",
	    "a" x 65536);
t_z80asm_error("defs 65535, 'a' \n defm 97, \"a\" \n",
	       "Error at file 'test.asm' line 2: max. code size of 65536 bytes reached");

t_z80asm_ok(0, "defs 65534, 'a' \n defm 97 , \"a\" \n",
	    "a" x 65536);
t_z80asm_error("defs 65535, 'a' \n defm 97 , \"a\" \n",
	       "Error at file 'test.asm' line 2: max. code size of 65536 bytes reached");

t_z80asm_ok(0, "defs 65534, 'a' \n defm \"a\" , 97 \n",
	    "a" x 65536);
t_z80asm_error("defs 65535, 'a' \n defm \"a\" , 97 \n",
	       "Error at file 'test.asm' line 2: max. code size of 65536 bytes reached");

# BINARY - tested in directives.t

# Linker
write_file(asm1_file(), "defb 0xAA");

write_file(asm_file(), "defs 65535, 0xAA");
t_z80asm_capture(asm_file()." ".asm1_file(), "", "", 0);
t_z80asm_capture("-d -b ".asm_file()." ".asm1_file(), "", "", 0);
t_binary(read_binfile(bin_file()),
	"\xAA" x 65536);

write_file(asm_file(), "defs 65536, 0xAA");
t_z80asm_capture(asm_file()." ".asm1_file(), "", "", 0);
t_z80asm_capture("-d -b ".asm_file()." ".asm1_file(), "",
	"Error: max. code size of 65536 bytes reached\n", 1);

# parseline
t_z80asm_ok(0, "defs 65535, 0xAA \n defb 0xAA \n",
	    "\xAA" x 65536);
t_z80asm_error("defs 65536, 0xAA \n defb 0xAA \n",
	       "Error at file 'test.asm' line 2: max. code size of 65536 bytes reached");


#------------------------------------------------------------------------------
# error_symbol_redefined 		-> tested in symtab.t
# error_symbol_redefined_module	-> tested in symtab.t
# error_symbol_decl_local  		-> tested in symtab.t
# error_symbol_redecl			-> tested in symtab.t

#------------------------------------------------------------------------------
# error_illegal_src_filename
unlink_testfiles();
write_file(asm_file(), "nop");
t_z80asm_capture(asm_file()." -IllegalFilename", "",
		"Error: cannot read file '-IllegalFilename'\n", 1);

#------------------------------------------------------------------------------
# error_org_redefined - tested in directives.t

#------------------------------------------------------------------------------
# error_jr_not_local
unlink_testfiles();

t_z80asm(
	asm		=> " extern loop \n jr loop ",
	asm1	=> " public loop \n loop: ret ",
	bin		=> pack("C*", 0x18, 0x00, 0xc9),
);

#t_z80asm_error("
#	EXTERN loop
#	jr loop
#", "Error at file 'test.asm' line 3: relative jump address must be local");

#------------------------------------------------------------------------------
# error_obj_file_version
unlink_testfiles();
my $obj = objfile(NAME => "test", CODE => [["", -1, 1, "\x00"]] );
substr($obj,6,2)="99";		# change version
write_file(o_file(), $obj);
t_z80asm_capture("-b  ".o_file(), "", <<"END", 1);
Error: object file 'test.o' version 99, expected version 16
END

#------------------------------------------------------------------------------
# error_not_obj_file
unlink_testfiles();
write_file(o_file(), "not an object");
sleep 0.500;
write_file(asm_file(), "nop");
t_z80asm_capture("-b -d ".asm_file(), "", "", 0);
t_binary(read_binfile(o_file()), objfile(NAME => "test",
										   CODE => [["", -1, 1, "\x00"]],
										   ));
t_binary(read_binfile(bin_file()), "\x00");

# CreateLib uses a different error call
unlink_testfiles();
write_file(o_file(), "not an object");
sleep 0.500;
write_file(asm_file(), "nop");
t_z80asm_capture("-x".lib_file()." -d ".asm_file(), "", "", 0);
t_binary(read_binfile(lib_file()), libfile(objfile(NAME => "test",
												   CODE => [["", -1, 1, "\x00"]])));
unlink_testfiles();
write_binfile(o_file(), objfile( NAME => "test",
								   CODE => [["", -1, 1, "\0\0"]],
								   SYMBOLS => [ ["Z", "Z", "", 0, "ABCD", "", 0] ] ));
t_z80asm_capture("-b -d ".o_file(),
				 "",
				 "Error at module 'test': file 'test.o' not an object file\n",
				 1);

#------------------------------------------------------------------------------
# error_not_lib_file
unlink_testfiles();
write_file(asm_file(), "nop");
write_file(lib_file(), "not a library");
t_z80asm_capture("-b -l".lib_file()." ".asm_file(), "",
		"Error: file 'test.lib' not a library file\n",
		1);

#------------------------------------------------------------------------------
# error_lib_file_version
unlink_testfiles();
$lib = libfile(objfile(NAME => "test", CODE => [["", -1, 1, "\x00"]] ));
substr($lib,6,2)="99";		# change version
write_file(asm_file(), "nop");
write_file(lib_file(), $lib);
t_z80asm_capture("-b -l".lib_file()." ".asm_file(), "", <<"END", 1);
Error: library file 'test.lib' version 99, expected version 16
END

#------------------------------------------------------------------------------
# warn_expr_in_parens
unlink_testfiles();
write_file("test.asm", "cp (16)");
t_z80asm_capture("-b test.asm", "",
		"Warning at file 'test.asm' line 1: interpreting indirect value as immediate\n",
		0);
t_binary(read_binfile("test.bin"), "\xFE\x10");

unlink_testfiles();
write_file("test.asm", "cp +(16)");
t_z80asm_capture("-b test.asm", "",
		"",
		0);
t_binary(read_binfile("test.bin"), "\xFE\x10");

#------------------------------------------------------------------------------
# error_expected_const_expr
unlink_testfiles();
write_file("test.asm", <<'END');
	extern ZERO
	bit ZERO,a
	set ZERO,a
	res ZERO,a
	im 	ZERO
	rst ZERO
	bit undefined,a
	set undefined,a
	res undefined,a
	im 	undefined
	rst	undefined
END
t_z80asm_capture("-b test.asm", "", <<'ERR', 1);
Error at file 'test.asm' line 2: expected constant expression
Error at file 'test.asm' line 3: expected constant expression
Error at file 'test.asm' line 4: expected constant expression
Error at file 'test.asm' line 5: expected constant expression
Error at file 'test.asm' line 6: expected constant expression
Error at file 'test.asm' line 7: symbol 'undefined' not defined
Error at file 'test.asm' line 8: symbol 'undefined' not defined
Error at file 'test.asm' line 9: symbol 'undefined' not defined
Error at file 'test.asm' line 10: symbol 'undefined' not defined
Error at file 'test.asm' line 10: expected constant expression
Error at file 'test.asm' line 11: symbol 'undefined' not defined
Error at file 'test.asm' line 11: expected constant expression
ERR

unlink_testfiles();
done_testing();
