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
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/errors.t,v 1.15 2014-04-28 22:16:11 pauloscustodio Exp $
#
# Test error messages

use Modern::Perl;
use Test::More;
use File::Copy;
use File::Path qw(make_path remove_tree);;
use Capture::Tiny::Extended 'capture';
use Test::Differences; 
require 't/test_utils.pl';

my $COMMA = get_legacy() ? "&" : ",";

#------------------------------------------------------------------------------
# Black box tests
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# fatal_divide_by_zero
diag "BUG_0040";
unlink_testfiles();
t_z80asm_error("ld a, 1/0",
	"Error at file 'test.asm' line 1: division by zero",
	"-l");
t_z80asm_error("ld a, 1%0",
	"Error at file 'test.asm' line 1: division by zero",
	"-l");

#------------------------------------------------------------------------------
# fatal_read_file
unlink_testfiles();
t_z80asm_capture(asm_file(), "",
		"Error: cannot read file '".asm_file()."'\n".
		"1 errors occurred during assembly\n",
		1);

unlink_testfiles();
t_z80asm_error('
	ld a, 1
	include "'.inc_file().'"
	ld b, 1
	', 
	"Error at file 'test.asm' line 3: cannot read file 'test.inc'",
	"-l");

unlink_testfiles();
t_z80asm_error('
	binary "'.inc_file().'"
	', 
	"Error at file 'test.asm' line 2: cannot read file 'test.inc'",
	"-l");

unlink_testfiles();
write_file(asm_file(), "nop");
t_z80asm_capture("-r0 -b -ixxxx ".asm_file(), "", 
		"Error: cannot read file 'xxxx.lib'\n".
		"1 errors occurred during assembly\n",
		1);
	
#------------------------------------------------------------------------------
# fatal_write_file
unlink_testfiles();
make_path( err_file() );
write_file( asm_file(), 'nop' );
t_z80asm_capture("-r0 -b -c ".asm_file(),
				"", 
				"Error: cannot write file 'test.err'\n".
				"1 errors occurred during assembly\n",
				1);
remove_tree( err_file() );

unlink_testfiles();
make_path( lst_file() );
write_file( asm_file(), 'nop' );
t_z80asm_capture("-l -r0 -b -c ".asm_file(),
				"", 
				"Error: cannot write file 'test.lst'\n".
				"1 errors occurred during assembly\n",
				1);
remove_tree( lst_file() );

unlink_testfiles();
make_path( sym_file() );
write_file( asm_file(), 'nop' );
t_z80asm_capture("-r0 -b -c ".asm_file(),
				"", 
				"Error: cannot write file 'test.sym'\n".
				"1 errors occurred during assembly\n",
				1);
remove_tree( sym_file() );

unlink_testfiles();
make_path( obj_file() );
write_file( asm_file(), 'nop' );
t_z80asm_capture("-l -r0 -b -c ".asm_file(),
				"", 
				"Error: cannot write file 'test.obj'\n".
				"1 errors occurred during assembly\n",
				1);
remove_tree( obj_file() );

unlink_testfiles();
make_path( bin_file() );
write_file( asm_file(), 'nop' );
t_z80asm_capture("-r0 -b -c ".asm_file(),
				"", 
				"Error: cannot write file 'test.bin'\n".
				"1 errors occurred during assembly\n",
				1);
remove_tree( bin_file() );

#------------------------------------------------------------------------------
# Errors
check_errors("", <<'ASM');
	ldx						; unknown identifier
	ld						; syntax error
	ld a,1+					; syntax error in expression

	defm ";					; unclosed quoted string
	defm "hello				; unclosed quoted string

	defb '					; invalid single quoted character
	defb 'x					; invalid single quoted character
	defb ''					; invalid single quoted character
	defb 'he'				; invalid single quoted character

	call_oz		0      		; integer '0' out of range
	call_oz		65536		; integer '65536' out of range
	
	call_pkg	-1    		; integer '-1' out of range
	call_pkg	65536 		; integer '65536' out of range
	
	fpp			0    		; integer '0' out of range
	fpp			255	 		; integer '255' out of range
	fpp			256	 		; integer '256' out of range
	
	invoke		-1    		; integer '-1' out of range
	invoke		65536 		; integer '65536' out of range
	
; RST out of range
	rst	undefined		   	; symbol not defined
	rst -1					; integer '-1' out of range
	rst 1					; integer '1' out of range
	rst 7					; integer '7' out of range
	rst 9					; integer '9' out of range
	rst 15					; integer '15' out of range
	rst 17					; integer '17' out of range
	rst 23					; integer '23' out of range
	rst 25					; integer '25' out of range
	rst 31					; integer '31' out of range
	rst 33					; integer '33' out of range
	rst 39					; integer '39' out of range
	rst 41					; integer '41' out of range
	rst 47					; integer '47' out of range
	rst 49					; integer '49' out of range
	rst 55					; integer '55' out of range
	rst 57					; integer '57' out of range
	
; bit out of range
	bit -1,a				; integer '-1' out of range
	bit  8,a				; integer '8' out of range
	bit undefined,a			; symbol not defined
	res -1,a				; integer '-1' out of range
	res  8,a				; integer '8' out of range
	res undefined,a			; symbol not defined
	set -1,a				; integer '-1' out of range
	set  8,a				; integer '8' out of range
	set undefined,a			; symbol not defined

; im out of range
	im 	-1					; integer '-1' out of range
	im 	3					; integer '3' out of range
	im 	undefined			; symbol not defined

; jump relative out of range
	djnz ASMPC-0x7F			; integer '-129' out of range
	djnz ASMPC+0x82			; integer '128' out of range
	jr ASMPC-0x7F			; integer '-129' out of range
	jr ASMPC+0x82			; integer '128' out of range
	jr nz,ASMPC-0x7F		; integer '-129' out of range
	jr nz,ASMPC+0x82		; integer '128' out of range
	jr  z,ASMPC-0x7F		; integer '-129' out of range
	jr  z,ASMPC+0x82		; integer '128' out of range
	jr nc,ASMPC-0x7F		; integer '-129' out of range
	jr nc,ASMPC+0x82		; integer '128' out of range
	jr  c,ASMPC-0x7F		; integer '-129' out of range
	jr  c,ASMPC+0x82		; integer '128' out of range

ASM

#------------------------------------------------------------------------------
# Errors on RABBIT
check_errors("-RCMX000", <<'ASM');
	daa						; illegal identifier
	inc ixl					; illegal identifier
	inc ixh					; illegal identifier
	inc iyl					; illegal identifier
	inc iyh					; illegal identifier
	ld (bc),b				; illegal identifier
	di 						; illegal identifier
	ei	 					; illegal identifier
	halt					; illegal identifier
	im	0					; illegal identifier
	im	1   				; illegal identifier
	im	2   				; illegal identifier
	retn					; illegal identifier
	rst	0x00				; illegal identifier
	rst	0x08				; illegal identifier
	rst	0x30				; illegal identifier
	in a,(N)				; illegal identifier
	in a,(c)				; illegal identifier
	in d,(c)				; illegal identifier
	ini						; illegal identifier
	inir					; illegal identifier
	ind						; illegal identifier
	indr					; illegal identifier
	out (N),a				; illegal identifier
	out (c),a				; illegal identifier
	out (c),d				; illegal identifier
	outi					; illegal identifier
	otir					; illegal identifier
	outd					; illegal identifier
	otdr					; illegal identifier
ASM

#------------------------------------------------------------------------------
# error_expression 
unlink_testfiles();
write_binfile(obj_file(), objfile( NAME => "test", CODE => "\0\0", EXPR => [ [C => 0, 0, "*+VAL"] ] ));
t_z80asm_capture("-r0 -a ".obj_file(),
				 "",
				 "Error at file 'test.asm' module 'test': syntax error in expression\n".
				 "Error at file 'test.asm' module 'test': error in expression '*+VAL'\n".
				 "2 errors occurred during assembly\n",
				 1);

#------------------------------------------------------------------------------
# Warnings
check_warnings("", <<'ASM');

; Byte
	ld a, -129			; 3E 7F			; integer '-129' out of range
	ld a,-128			; 3E 80			;
	ld a,0				; 3E 00			;
	ld a,255			; 3E FF			;
	ld a,256			; 3E 00			; integer '256' out of range

; SignedByte
	ld (ix-129),-1		; DD 36 7F FF	; integer '-129' out of range
	ld (ix-128),-1		; DD 36 80 FF	;
	ld (ix),-1			; DD 36 00 FF	;
	ld (ix+127),-1		; DD 36 7F FF	;
	ld (ix+128),-1		; DD 36 80 FF	; integer '128' out of range

; Word
	ld bc,-32769		; 01 FF 7F		; integer '-32769' out of range
	ld bc,-32768		; 01 00 80		; 
	ld bc, 65535		; 01 FF FF		; 
	ld bc, 65536		; 01 00 00		; integer '65536' out of range

; 32-bit arithmetic, long range is not tested on a 32bit long
	defl 0xFFFFFFFF+1	; 00 00 00 00	; 

; call out of range
	call -32769			; CD FF 7F		; integer '-32769' out of range
	call -32768			; CD 00 80		; 
	call -1				; CD FF FF		; 
	call 65535			; CD FF FF		; 
	call 65536			; CD FF FF		; integer '65536' out of range

ASM

#------------------------------------------------------------------------------
# warn_option_deprecated
unlink_testfiles();
write_file(asm_file(), "");
t_z80asm_capture("-t0 ".asm_file(), "",
		"Warning: option '-t' is deprecated\n",
		0);

#------------------------------------------------------------------------------
# warn_int_range / error_int_range on pass2 and multi-module assembly
unlink_testfiles();

write_file(asm_file(), <<'ASM');
	extern G_32769, G_32768, G_129, G_128, G0, G127, G128, G255, G256, G65535, G65536

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

; Word = -32769
	ld	bc, L_32769
	ld	bc, G_32769
	ld	bc, G0 - 32769

; Word = -32768
	ld	bc, L_32768
	ld	bc, G_32768
	ld	bc, G0 - 32768

; Word = 65535
	ld	bc, L65535
	ld	bc, G65535
	ld	bc, G0 + 65535

; Word = 65536
	ld	bc, L65536
	ld	bc, G65536
	ld	bc, G0 + 65536

; Local variables
	defc L_32769 = -32769
	defc L_32768 = -32768
	defc L_129   = -129
	defc L_128   = -128
	defc L255    =  255
	defc L256    =  256
	defc L127    =  127
	defc L128    =  128
	defc L65535  =  65535
	defc L65536  =  65536
ASM

write_file(asm1_file(), <<'ASM1');

; Global variables
	public G_32769, G_32768, G_129, G_128, G0, G127, G128, G255, G256, G65535, G65536
	defc G_32769 = -32769
	defc G_32768 = -32768
	defc G_129   = -129
	defc G_128   = -128
	defc G0      =  0
	defc G127    =  127
	defc G128    =  128
	defc G255    =  255
	defc G256    =  256
	defc G65535  =  65535
	defc G65536  =  65536
ASM1

t_z80asm_capture("-r0 -b ".asm_file()." ".asm1_file(), "", <<'ERR', 0);
Warning at file 'test.asm' module 'test' line 4: integer '-129' out of range
Warning at file 'test.asm' module 'test' line 19: integer '256' out of range
Warning at file 'test.asm' module 'test' line 24: integer '-129' out of range
Warning at file 'test.asm' module 'test' line 39: integer '128' out of range
Warning at file 'test.asm' module 'test' line 44: integer '-32769' out of range
Warning at file 'test.asm' module 'test' line 59: integer '65536' out of range
Warning at file 'test.asm' module 'test': integer '-129' out of range in expression 'G_129'
Warning at file 'test.asm' module 'test': integer '-129' out of range in expression 'G0-129'
Warning at file 'test.asm' module 'test': integer '256' out of range in expression 'G256'
Warning at file 'test.asm' module 'test': integer '256' out of range in expression 'G0+256'
Warning at file 'test.asm' module 'test': integer '-129' out of range in expression 'G_129'
Warning at file 'test.asm' module 'test': integer '-129' out of range in expression 'G0-129'
Warning at file 'test.asm' module 'test': integer '128' out of range in expression 'G128'
Warning at file 'test.asm' module 'test': integer '128' out of range in expression 'G0+128'
Warning at file 'test.asm' module 'test': integer '-32769' out of range in expression 'G_32769'
Warning at file 'test.asm' module 'test': integer '-32769' out of range in expression 'G0-32769'
Warning at file 'test.asm' module 'test': integer '65536' out of range in expression 'G65536'
Warning at file 'test.asm' module 'test': integer '65536' out of range in expression 'G0+65536'
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
		0x01, 0xFF, 0x7F,
		0x01, 0xFF, 0x7F,
		0x01, 0xFF, 0x7F,
		0x01, 0x00, 0x80,
		0x01, 0x00, 0x80,
		0x01, 0x00, 0x80,
		0x01, 0xFF, 0xFF,
		0x01, 0xFF, 0xFF,
		0x01, 0xFF, 0xFF,
		0x01, 0x00, 0x00,
		0x01, 0x00, 0x00,
		0x01, 0x00, 0x00,
));

#------------------------------------------------------------------------------
# assemble, check errors
#------------------------------------------------------------------------------
sub check_errors {	
	my($options, $code) = @_;
	
	my $line = 0;
	my $asm = "";
	my $errors = "";
	my $num_errors;
	
	for (split(/\n/, $code)) {
		$line++;
		$asm .= "$_\n";
		diag($1) if /;\s+((BUG_|CH_)\d+)/;
		
		my($error_text) = /\s+;\s*(.*)/ or next;
		$errors .= "Error at file '".asm_file()."' line ".$line.": ".$error_text."\n";
		$num_errors++;
	}
	$errors .= $num_errors." errors occurred during assembly\n";
	
	write_file(asm_file(), $asm);
	t_z80asm_capture($options." ".asm_file(), "", $errors, 1 );
}

#------------------------------------------------------------------------------
# assemble, check warnings
#------------------------------------------------------------------------------
sub check_warnings {	
	my($options, $code, $add_options, $link_warnings) = @_;
	
	my $line = 0;
	my $asm = "";
	my $bin = "";
	my $warnings = "";
	
	for (split(/\n/, $code)) {
		$line++;
		$asm .= "$_\n";
		diag($1) if /;\s+((BUG_|CH_)\d+)/;
		
		my($hex, $warning_text) = /\s+;([0-9A-F \t]+);\s*((.+)?)/i or next;
		for (split(' ', $hex)) {
			$bin .= chr(hex($_));
		}
		if ($warning_text) {
			$warnings .= "Warning at file '".asm_file()."' line ".
						 $line.": ".$warning_text."\n";
		}
	}
	
	write_file(asm_file(), $asm);
	t_z80asm_capture($options." ".asm_file()." ".($add_options || ""), "", 
					 $warnings.($link_warnings || ""), 0 );
}

# defvar out of range
t_z80asm(
	asm		=> "defvars 0
				{
					s1  ds.b 1
					s2  ds.b 65536
					s3  ds.b 1
				}
				defl s1, s2, s3
			   ",
	bin		=> "\0\0\0\0"."\1\0\0\0"."\1\0\1\0",
);

t_z80asm(
	asm		=> "defvars 0
				{
					s1  ds.b 0
				}
			   ",
	err		=> "Error at file 'test.asm' line 3: integer '0' out of range",
);

t_z80asm(
	asm		=> "defvars 0
				{
					s1  ds.b 65537
				}
			   ",
	err		=> "Error at file 'test.asm' line 3: integer '65537' out of range",
);


# defs out of range
t_z80asm(
	asm		=> "defs -1",
	err		=> "Error at file 'test.asm' line 1: integer '-1' out of range",
);

t_z80asm(
	asm		=> "defs 0",
	bin		=> "",
);

t_z80asm(
	asm		=> "defs 1",
	bin		=> "\x00",
);

t_z80asm(
	asm		=> "defs 1, 0xAA",
	bin		=> "\xAA",
);

t_z80asm(
	asm		=> "defs 65536",
	bin		=> "\x00" x 65536,
);

t_z80asm(
	asm		=> "defs 65536,0xAA",
	bin		=> "\xAA" x 65536,
);

t_z80asm(
	asm		=> "defs 65537",
	err		=> "Error at file 'test.asm' line 1: max. code size of 65536 bytes reached",
);


# org out of range
t_z80asm(
	asm		=> "org -1",
	err		=> "Error at file 'test.asm' line 1: integer '-1' out of range",
);

t_z80asm(
	asm		=> "org 0",
	bin		=> "",
);

diag "BUG org 65535 does not work, 0xFFFF is used as a marker for ORG not defined";

t_z80asm(
	asm		=> "org 65534",
	bin		=> "",
);

t_z80asm(
	asm		=> "org 65536",
	err		=> "Error at file 'test.asm' line 1: integer '65536' out of range",
);


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
		err		=> "Error at file 'test.asm' module 'test' line 1: integer '-129' out of range",
	);

	t_z80asm(
		asm		=> "$jump ASMPC+2+128",
		err		=> "Error at file 'test.asm' line 1: integer '128' out of range",
	);

	t_z80asm(
		asm		=> "$jump label : defc label = ASMPC+128",
		err		=> "Error at file 'test.asm' module 'test' line 1: integer '128' out of range",
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
t_z80asm_error("ld a,NOSYMBOL", "Error at file 'test.asm' module 'test' line 1: symbol not defined");

#------------------------------------------------------------------------------
# error_not_defined_expr
my $lib = lib_file(); $lib =~ s/\.lib$/2.lib/i;
unlink_testfiles($lib);
write_file(asm_file(), "module main \n main: ret");
t_z80asm_capture("-x".$lib." ".asm_file(), "", "", 0);
ok -f $lib;
write_file(asm_file(), "EXTERN main \n call main");
t_z80asm_capture("-r0 -b -i".$lib." ".asm_file(), "",
		"Error at file 'test.asm' module 'test': symbol not defined in expression 'main'\n".
		"1 errors occurred during assembly\n", 
		1);

#------------------------------------------------------------------------------
# error_no_src_file
unlink_testfiles();
t_z80asm_capture("-b", "", 
		"Error: source filename missing\n".
		"1 errors occurred during assembly\n", 1);

#------------------------------------------------------------------------------
# error_illegal_option
unlink_testfiles();
write_file(asm_file(), "");
t_z80asm_capture("-Zillegaloption ".asm_file(), "",
		"Error: illegal option '-Zillegaloption'\n1 errors occurred during assembly\n",
		1);

#------------------------------------------------------------------------------
# fatal_max_codesize
unlink_testfiles();

# DEFB
t_z80asm_ok(0, "defs 65535, 0xAA \n defb 0xAA \n",
	    "\xAA" x 65536);
t_z80asm_error("defs 65536, 0xAA \n defb 0xAA \n",
	       "Error at file 'test.asm' line 2: max. code size of 65536 bytes reached");

t_z80asm_ok(0, "defs 65534, 0xAA \n defb 0xAA,0xAA \n",
	    "\xAA" x 65536);
t_z80asm_error("defs 65535, 0xAA \n defb 0xAA,0xAA \n",
	       "Error at file 'test.asm' line 2: max. code size of 65536 bytes reached");

# DEFW
t_z80asm_ok(0, "defs 65534, 0xAA \n defw 0xAAAA \n",
	    "\xAA" x 65536);
t_z80asm_error("defs 65535, 0xAA \n defw 0xAAAA \n",
	       "Error at file 'test.asm' line 2: max. code size of 65536 bytes reached");

t_z80asm_ok(0, "defs 65532, 0xAA \n defw 0xAAAA, 0xAAAA \n",
	    "\xAA" x 65536);
t_z80asm_error("defs 65533, 0xAA \n defw 0xAAAA, 0xAAAA \n",
	       "Error at file 'test.asm' line 2: max. code size of 65536 bytes reached");

# DEFS
t_z80asm_ok(0, "defs 65536,0xAA", "\xAA" x 65536);
t_z80asm_error("defs 65537,0xAA", "Error at file 'test.asm' line 1: max. code size of 65536 bytes reached");

# DEFP
t_z80asm_ok(0, "defs 65533, 0xAA \n defp 0xAAAA,0xAA \n",
	    "\xAA" x 65536);
t_z80asm_error("defs 65534, 0xAA \n defp 0xAAAA,0xAA \n",
	       "Error at file 'test.asm' line 2: max. code size of 65536 bytes reached");

# DEFL
t_z80asm_ok(0, "defs 65532, 0xAA \n defl 0xAAAAAAAA \n",
	    "\xAA" x 65536);
t_z80asm_error("defs 65533, 0xAA \n defl 0xAAAAAAAA \n",
	       "Error at file 'test.asm' line 2: max. code size of 65536 bytes reached");

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

t_z80asm_ok(0, "defs 65534, 'a' \n defm 97 $COMMA \"a\" \n",
	    "a" x 65536);
t_z80asm_error("defs 65535, 'a' \n defm 97 $COMMA \"a\" \n",
	       "Error at file 'test.asm' line 2: max. code size of 65536 bytes reached");

t_z80asm_ok(0, "defs 65534, 'a' \n defm \"a\" $COMMA 97 \n",
	    "a" x 65536);
t_z80asm_error("defs 65535, 'a' \n defm \"a\" $COMMA 97 \n",
	       "Error at file 'test.asm' line 2: max. code size of 65536 bytes reached");

# BINARY
my $bin_file = bin_file(); $bin_file =~ s/\.bin$/2.bin/i;
write_file($bin_file, {binmode => ':raw'}, "a" x 65536);
t_z80asm_ok(0, 'binary "'.$bin_file.'"',
	    "a" x 65536);

write_file($bin_file, {binmode => ':raw'}, "a" x 65537);
t_z80asm_error('binary "'.$bin_file.'"',
	       "Error at file 'test.asm' line 1: max. code size of 65536 bytes reached");

# Linker
my $asm_file2 = asm_file(); $asm_file2 =~ s/\.asm$/2.asm/i;
my $file2_base = $asm_file2; $file2_base =~ s/\.asm$//i;
write_file($asm_file2, "defb 0xAA");

write_file(asm_file(), "defs 65535, 0xAA");
t_z80asm_capture("-r0 -b ".asm_file()." $asm_file2", "", "", 0);
t_binary(read_binfile(bin_file()),
	"\xAA" x 65536);

write_file(asm_file(), "defs 65536, 0xAA");
t_z80asm_capture("-r0 -b ".asm_file()." $asm_file2", "",
	"Error at module 'test2': max. code size of 65536 bytes reached\n".
	"1 errors occurred during assembly\n", 1);

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
# error_module_redefined
unlink_testfiles();
t_z80asm_error("
	module aa
	module bb
", "Error at file 'test.asm' line 3: module name already defined");

#------------------------------------------------------------------------------
# error_illegal_src_filename
unlink_testfiles();
write_file(asm_file(), "nop");
t_z80asm_capture(asm_file()." -IllegalFilename", "",
		"Error: illegal source filename '-IllegalFilename'\n".
		"1 errors occurred during assembly\n", 1);
		
#------------------------------------------------------------------------------
# error_org_not_defined
unlink_testfiles();
t_z80asm(
	org		=> -1,
	asm		=> "org 0x1000 \n start: defw start",
	bin		=> "\x00\x10",
);

t_z80asm(
	org		=> 0x1000,
	asm		=> "start: defw start",
	bin		=> "\x00\x10",
);

unlink_testfiles();
write_file( asm_file(), "start: defw start" );
my($stdout, $stderr, $return) = capture {
	system z80asm()." -l -b ".asm_file();
};
is $stdout, "", "output";
is $stderr, "Error at module 'test': ORG not defined\n1 errors occurred during assembly\n", "error";
ok -f err_file(), "error file";
is read_file( err_file() ), "Error at module 'test': ORG not defined\n", "error file ok";
ok -f lst_file(), "lst generated in assembly phase, ok";
ok -f obj_file(), "obj generated in assembly phase, ok";
ok ! -f bin_file(), "no bin file";

#------------------------------------------------------------------------------
# error_jr_not_local
unlink_testfiles();
t_z80asm_error("
	EXTERN loop
	jr loop
", "Error at file 'test.asm' module 'test' line 3: relative jump address must be local");


#------------------------------------------------------------------------------
# error_env_not_defined
unlink_testfiles();

# create a lib name that is not removed by unlink_testfiles()
$lib = lib_file(); $lib =~ s/\.lib$/lib.lib/i;
unlink_testfiles($lib);

# create a library without Z80_STDLIB
delete $ENV{Z80_STDLIB};
write_file(asm_file(), "
	PUBLIC one
one: 
	ld a,1
	ret
");
t_z80asm_capture("-x".lib_file()." ".asm_file(), "", "", 0);
ok -f obj_file(), obj_file()." created";
ok -f lib_file(), lib_file()." created";

# save for later
ok copy(lib_file(), $lib), "create $lib";

is unlink(obj_file(), lib_file()), 2, "delete old obj and lib";

# ERR_NO_ENVVAR => 30
delete $ENV{Z80_STDLIB};
t_z80asm_capture("-x ".asm_file(), "", 
		"Error: environment variable 'Z80_STDLIB' not defined\n".
		"1 errors occurred during assembly\n", "stderr",
		1);

# create the same library with Z80_STDLIB
$ENV{Z80_STDLIB} = lib_file();
t_z80asm_capture("-x ".asm_file(), "", "", 0);
ok -f obj_file(), obj_file()." created";
ok -f lib_file(), lib_file()." created";

# link with the library without Z80_STDLIB
delete $ENV{Z80_STDLIB};
t_z80asm_ok(0, "
	EXTERN one
	jp one
", "\xC3\x03\x00\x3E\x01\xC9", "-i$lib");

# link with the library with Z80_STDLIB
$ENV{Z80_STDLIB} = $lib;
t_z80asm_ok(0, "
	EXTERN one
	jp one
", "\xC3\x03\x00\x3E\x01\xC9", "-i");

# ERR_NO_ENVVAR => 30
delete $ENV{Z80_STDLIB};
t_z80asm_capture("-x ".asm_file(), "", 
		"Error: environment variable 'Z80_STDLIB' not defined\n".
		"1 errors occurred during assembly\n", "stderr",
		1);

#------------------------------------------------------------------------------
# error_not_obj_file
unlink_testfiles();
write_file(asm_file(), "nop");
write_file(obj_file(), "not an object");
t_z80asm_capture("-r0 -b -d ".obj_file(), "", "", 0);
t_binary(read_binfile(obj_file()), objfile(NAME => "test", CODE => "\x00", ORG => 0));
t_binary(read_binfile(bin_file()), "\x00");
	
# CreateLib uses a different error call
unlink_testfiles();
write_file(asm_file(), "nop");
write_file(obj_file(), "not an object");
t_z80asm_capture("-x".lib_file()." -d ".obj_file(), "", "", 0);
t_binary(read_binfile(lib_file()), libfile(objfile(NAME => "test", CODE => "\x00")));

unlink_testfiles();
write_binfile(obj_file(), objfile( NAME => "test", CODE => "\0\0", 
								   SYMBOLS => [ [Z => Z => 0, "ABCD"] ] ));
t_z80asm_capture("-r0 -a ".obj_file(),
				 "",
				 "Error at module 'test': file 'test.obj' not an object file\n".
				 "Error at module 'test': file 'test.obj' not an object file\n".
				 "2 errors occurred during assembly\n",
				 1);

#------------------------------------------------------------------------------
# error_not_lib_file
unlink_testfiles();
write_file(asm_file(), "nop");
write_file(lib_file(), "not a library");
t_z80asm_capture("-r0 -b -i".lib_file()." ".asm_file(), "",
		"Error: file 'test.lib' not a library file\n".
		"1 errors occurred during assembly\n",
		1);

#------------------------------------------------------------------------------
# fatal_include_recursion
unlink_testfiles();
write_file(asm_file(), 'include "'.inc_file().'"');
write_file(inc_file(), 'include "'.inc_file().'"');
t_z80asm_capture(asm_file(), "",
		"Error at file 'test.inc' line 1: cannot include file 'test.inc' recursively\n".
		"1 errors occurred during assembly\n",
		1);


#------------------------------------------------------------------------------
# White box tests
#------------------------------------------------------------------------------
unlink_testfiles();

my $objs = "errors.o scan.o lib/class.o lib/strutil.o lib/strhash.o lib/list.o lib/fileutil.o options.o model.o lib/srcfile.o hist.o";

# get init code except init() and main()
my $init = <<'END';

#include "symbol.h"

struct module *CURRENTMODULE;
FILE *errfile;
size_t get_PC( void ) { return 0; }
void list_start_line( size_t address, char *source_file, int source_line_nr, char *line ) 
{	
	warn("%04X %-16s %5d %s", address, source_file, source_line_nr, line);
}
char *CreateLibfile( char *filename ) {return NULL;}
char *GetLibfile( char *filename ) {return NULL;}
Symbol *define_static_def_sym( char *name, long value ) {return NULL;}
char ident[MAXLINE];
char separators[MAXLINE];

END

t_compile_module($init, <<'END', $objs);
#define ERROR return __LINE__
#define check_count(e) if (get_num_errors() != e) ERROR;

	check_count(0);
	
	warn("Information\n");
	info_total_errors();
	check_count(0);

	warn("Warning\n");
	warn_option_deprecated("-t");
	check_count(0);

	warn("Error\n");
	error_syntax();
	check_count(1);

	warn("Fatal error not caught\n");
	fatal_read_file("file.asm");
	warn("NOT REACHED\n");	
END

t_run_module([], '', <<'ERR', 1);
Information
0 errors occurred during assembly
Warning
Warning: option '-t' is deprecated
Error
Error: syntax error
Fatal error not caught
Error: cannot read file 'file.asm'
Uncaught runtime exception at errors.c(1)
ERR


t_compile_module($init, <<'END', $objs);
#define ERROR return __LINE__
#define check_count(e) if (get_num_errors() != e) ERROR;
#define SYNTAX(file,module,line) \
	_count = get_num_errors(); \
	set_error_file(file); \
	set_error_module(module); \
	set_error_line(line); \
	error_syntax(); \
	check_count(_count + 1)
	
#define DOUBLE(x) #x #x
	int _count;

	check_count(0);
	
	warn("Fatal error\n");
	TRY
	{
		fatal_read_file("file.asm");
		warn("NOT REACHED\n");	
	}
	FINALLY
	{
		if (! THROWN()) ERROR;
	}
	ETRY;
	check_count(1);
	
	SYNTAX(	NULL,		NULL,	0 );
	SYNTAX(	NULL,		NULL,	1 );
	SYNTAX(	NULL,		"TEST",	0 );
	SYNTAX(	NULL,		"TEST",	1 );
	SYNTAX(	"test.asm",	NULL,	0 );
	SYNTAX(	"test.asm",	NULL,	1 );
	SYNTAX(	"test.asm",	"TEST",	0 );
	SYNTAX(	"test.asm",	"TEST",	1 );

	set_error_null();
	check_count(9);
	error_syntax();
	check_count(10);
	
	reset_error_count();
	check_count(0);

	open_error_file("test1.err");
	close_error_file();
	
	error_syntax();
	
	open_error_file("test2.err");
	error_syntax();
	close_error_file();
	
	open_error_file("test3.err");
	error_syntax();
	
	open_error_file("test2.err");
	error_syntax();
	
END

t_run_module([], '', <<'ERR', 0);
Fatal error
Error: cannot read file 'file.asm'
Error: syntax error
Error at line 1: syntax error
Error at module 'TEST': syntax error
Error at module 'TEST' line 1: syntax error
Error at file 'test.asm': syntax error
Error at file 'test.asm' line 1: syntax error
Error at file 'test.asm' module 'TEST': syntax error
Error at file 'test.asm' module 'TEST' line 1: syntax error
Error: syntax error
Error: syntax error
Error: syntax error
Error: syntax error
Error: syntax error
ERR

ok ! -f "test1.err", "no errors, file deleted";

eq_or_diff_text scalar(read_file('test2.err')), <<'END';
Error: syntax error
Error: syntax error
END

eq_or_diff_text scalar(read_file('test3.err')), <<'END';
Error: syntax error
END


unlink_testfiles();
done_testing();


__END__
# $Log: errors.t,v $
# Revision 1.15  2014-04-28 22:16:11  pauloscustodio
# Merge tests in same compilation unit to speed up testing.
#
# Revision 1.14  2014/04/25 23:39:14  pauloscustodio
# Create asm and binary files at dev/Makefile using z80pack's assembler as benchmarks
# to test the z80asm assembler. These files are used during testing.
#
# Revision 1.13  2014/04/22 23:32:42  pauloscustodio
# Release 2.2.0 with major fixes:
#
# - Object file format changed to version 03, to include address of start
# of the opcode of each expression stored in the object file, to allow
# ASMPC to refer to the start of the opcode instead of the patch pointer.
# This solves long standing BUG_0011 and BUG_0048.
#
# - ASMPC no longer stored in the symbol table and evaluated as a separate
# token, to allow expressions including ASMPC to be relocated. This solves
# long standing and never detected BUG_0047.
#
# - Handling ASMPC during assembly simplified - no need to call inc_PC() on
# every assembled instruction, no need to store list of JRPC addresses as
# ASMPC is now stored in the expression.
#
# BUG_0047: Expressions including ASMPC not relocated - impacts call po|pe|p|m emulation in RCMX000
# ASMPC is computed on zero-base address of the code section and expressions
# including ASMPC are not relocated at link time.
# "call po, xx" is emulated in --RCMX000 as "jp pe, ASMPC+3; call xx".
# The expression ASMPC+3 is not marked as relocateable, and the resulting
# code only works when linked at address 0.
#
# BUG_0048: ASMPC used in JP/CALL argument does not refer to start of statement
# In "JP ASMPC", ASMPC is coded as instruction-address + 1 instead
# of instruction-address.
#
# BUG_0011 : ASMPC should refer to start of statememnt, not current element in DEFB/DEFW
# Bug only happens with forward references to relative addresses in expressions.
# See example from zx48.asm ROM image in t/BUG_0011.t test file.
# Need to change object file format to correct - need patchptr and address of instruction start.
#
# Revision 1.12  2014/04/13 20:32:10  pauloscustodio
# PUBLIC and EXTERN instead of LIB, XREF, XDEF, XLIB
#
# Revision 1.11  2014/04/06 22:55:54  pauloscustodio
# Merged errors.t and whitebox-errors.t
#
# Revision 1.10  2014/04/05 23:36:11  pauloscustodio
# CH_0024: Case-preserving, case-insensitive symbols
# Symbols no longer converted to upper-case, but still case-insensitive
# searched. Warning when a symbol is used with different case than
# defined. Intermidiate stage before making z80asm case-sensitive, to
# be more C-code friendly.
#
# Revision 1.9  2014/03/16 19:19:49  pauloscustodio
# Integrate use of srcfile in scanner, removing global variable z80asmfile
# and attributes CURRENTMODULE->cfile->line and CURRENTMODULE->cfile->fname.
#
# Revision 1.8  2014/03/11 00:15:13  pauloscustodio
# Scanner reads input line-by-line instead of character-by-character.
# Factor house-keeping at each new line read in the scanner getasmline().
# Add interface to allow back-tacking of the recursive descent parser by
# getting the current input buffer position and comming back to the same later.
# SetTemporaryLine() keeps a stack of previous input lines.
# Scanner handles single-quoted strings and returns a number.
# New error for single-quoted string with length != 1.
# Scanner handles double-quoted strings and returns the quoted string.
#
# Revision 1.7  2014/02/23 18:48:16  pauloscustodio
# CH_0021: New operators ==, !=, &&, ||, ?:
# Handle C-like operators ==, !=, &&, || and ?:.
# Simplify expression parser by handling composed tokens in lexer.
#
# Revision 1.6  2014/02/18 22:59:06  pauloscustodio
# BUG_0040: Detect and report division by zero instead of crashing
# BUG_0041: truncate negative powers to zero, i.e. pow(2,-1) == 0
#
# Revision 1.26  2014/02/08 18:30:49  pauloscustodio (whitebox-errors.t)
# lib/srcfile.c to read source files and handle recursive includes,
# used to read @lists, removed opts.files;
# model.c to hold global data model
#
# Revision 1.25  2014/01/20 23:29:18  pauloscustodio (whitebox-errors.t)
# Moved file.c to lib/fileutil.c
#
# Revision 1.5  2014/01/11 01:29:46  pauloscustodio
# Extend copyright to 2014.
# Move CVS log to bottom of file.
#
# Revision 1.23  2014/01/06 00:33:36  pauloscustodio (whitebox-errors.t)
# Use init.h mechanism, no need for main() calling init_errors
# and atexit(fini_errors); use Str and StrHash instead of glib.
#
# Revision 1.22  2014/01/02 17:18:17  pauloscustodio (whitebox-errors.t)
# StrList removed, replaced by List
#
# Revision 1.21  2014/01/01 21:23:48  pauloscustodio (whitebox-errors.t)
# Move generic file utility functions to lib/fileutil.c
#
# Revision 1.20  2013/12/30 02:05:34  pauloscustodio (whitebox-errors.t)
# Merge dynstr.c and safestr.c into lib/strutil.c; the new Str type
# handles both dynamically allocated strings and fixed-size strings.
# Replaced g_strchomp by chomp by; g_ascii_tolower by tolower;
# g_ascii_toupper by toupper; g_ascii_strcasecmp by stricompare.
#
# Revision 1.19  2013/12/26 23:42:28  pauloscustodio (whitebox-errors.t)
# Replace StringList from strutil by StrList in new strlis.c, to keep lists of strings (e.g. directory search paths)
#
# Revision 1.18  2013/12/25 14:39:50  pauloscustodio (whitebox-errors.t)
# Move strutil.c to the z80asm/lib directory
#
# Revision 1.17  2013/12/18 23:05:52  pauloscustodio (whitebox-errors.t)
# Move class.c to the z80asm/lib directory
#
# Revision 1.4  2013/12/15 13:20:25  pauloscustodio
# Move memory allocation routines to lib/xmalloc, instead of glib,
# introduce memory leak report on exit and memory fence check.
#
# Revision 1.15  2013/11/11 23:47:04  pauloscustodio (whitebox-errors.t)
# Move source code generation tools to dev/Makefile, only called on request,
# and keep the generated files in z80asm directory, so that build does
# not require tools used for the code generation (ragel, perl).
# Remove code generation for structs - use CLASS macro instead.
#
# Revision 1.14  2013/10/15 23:24:33  pauloscustodio (whitebox-errors.t)
# Move reading by lines or tokens and file reading interface to scan.rl
# to decouple file.c from scan.c.
# Add singleton interface to scan to be used by parser.
#
# Revision 1.3  2013/10/08 21:53:07  pauloscustodio
# Replace Flex-based lexer by a Ragel-based one.
# Add interface to file.c to read files by tokens, calling the lexer.
#
# Revision 1.2  2013/10/05 09:24:13  pauloscustodio
# Parse command line options via look-up tables:
# -t (deprecated)
#
# Revision 1.11  2013/09/23 23:14:10  pauloscustodio (whitebox-errors.t)
# Renamed SzList to StringList, simplified interface by assuming that
# list lives in memory util program ends; it is used for directory searches
# only. Moved interface to strutil.c, removed strlist.c.
#
# Revision 1.10  2013/09/22 21:04:21  pauloscustodio (whitebox-errors.t)
# New File and FileStack objects
#
# Revision 1.9  2013/09/09 00:20:45  pauloscustodio (whitebox-errors.t)
# Add default set of modules to t_compile_module:
# -DMEMALLOC_DEBUG xmalloc.c die.o except.o strpool.o
#
# Revision 1.1  2013/09/08 00:43:59  pauloscustodio
# New error module with one error function per error, no need for the error
# constants. Allows compiler to type-check error message arguments.
# Included the errors module in the init() mechanism, no need to call
# error initialization from main(). Moved all error-testing scripts to
# one file errors.t.
#
# Revision 1.7  2013/09/01 17:45:46  pauloscustodio (whitebox-errors.t)
# Need to include init.o to have memory initialized
#
# Revision 1.6  2013/09/01 00:18:30  pauloscustodio (whitebox-errors.t)
# - Replaced e4c exception mechanism by a much simpler one based on a few
#   macros. The former did not allow an exit(1) to be called within a
#   try-catch block.
#
# Revision 1.5  2013/05/11 00:29:26  pauloscustodio (whitebox-errors.t)
# CH_0021 : Exceptions on file IO show file name
# Keep a hash table of all opened file names, so that the file name
# is shown on a fatal error.
# Rename file IO funtions: f..._err to xf...
#
# Revision 1.4  2013/01/20 21:24:29  pauloscustodio (whitebox-errors.t)
# Updated copyright year to 2013
#
# Revision 1.3  2013/01/19 23:54:04  pauloscustodio (whitebox-errors.t)
# BUG_0023 : Error file with warning is removed in link phase
# z80asm -b f1.asm
# If assembling f1.asm produces a warning, the link phase removes the f1.err
# file hidding the warning.
#
# Revision 1.2  2012/06/14 15:01:27  pauloscustodio (whitebox-errors.t)
# Split safe strings from strutil.c to safestr.c
#
# Revision 1.1  2012/05/26 18:51:10  pauloscustodio (whitebox-errors.t)
# CH_0012 : wrappers on OS calls to raise fatal error
# CH_0013 : new errors interface to decouple calling code from errors.c
#
