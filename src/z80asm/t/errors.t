#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

#------------------------------------------------------------------------------
# error_expression
my $obj = objfile(NAME => "test",
				  CODE => [["", -1, 1, "\0\0"]],
				  EXPR => [["C", "test.asm",1, "", 0, 0, "", "*+VAL"]]);
spew("$test.o", $obj);
capture_nok("z88dk-z80asm -b -d $test.o", <<END);
test.asm:1: error: syntax error in expression
  ^---- *+VAL
END

#------------------------------------------------------------------------------
# warn_int_range / error_int_range on pass2 and multi-module assembly
#------------------------------------------------------------------------------
spew("$test.asm", <<'END');
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
END

spew("$test.1.asm", <<'END');
; Global variables
		public G_129, G_128, G0, G127, G128, G255, G256
		defc G_129   = -129
		defc G_128   = -128
		defc G0      =  0
		defc G127    =  127
		defc G128    =  128
		defc G255    =  255
		defc G256    =  256
END

run_ok("z88dk-z80asm -b $test.asm $test.1.asm 2> $test.err");
check_text_file("$test.err", <<END);
$test.asm:4: warning: integer range: -129
  ^---- L_129
$test.asm:19: warning: integer range: 0x100
  ^---- L256
$test.asm:24: warning: integer range: -129
  ^---- L_129
$test.asm:39: warning: integer range: 0x80
  ^---- L128
$test.asm:5: warning: integer range: -129
  ^---- G_129
$test.asm:6: warning: integer range: -129
  ^---- G0-129
$test.asm:20: warning: integer range: 0x100
  ^---- G256
$test.asm:21: warning: integer range: 0x100
  ^---- G0+256
$test.asm:25: warning: integer range: -129
  ^---- G_129
$test.asm:26: warning: integer range: -129
  ^---- G0-129
$test.asm:40: warning: integer range: 0x80
  ^---- G128
$test.asm:41: warning: integer range: 0x80
  ^---- G0+128
END

check_bin_file("$test.bin", bytes(
		0x3e, 0x7f,
		0x3e, 0x7f,
		0x3e, 0x7f,
		0x3e, 0x80,
		0x3e, 0x80,
		0x3e, 0x80,
		0x3e, 0xff,
		0x3e, 0xff,
		0x3e, 0xff,
		0x3e, 0x00,
		0x3e, 0x00,
		0x3e, 0x00,
		0xdd, 0x36, 0x7f, 0xff,
		0xdd, 0x36, 0x7f, 0xff,
		0xdd, 0x36, 0x7f, 0xff,
		0xdd, 0x36, 0x80, 0xff,
		0xdd, 0x36, 0x80, 0xff,
		0xdd, 0x36, 0x80, 0xff,
		0xdd, 0x36, 0x7f, 0xff,
		0xdd, 0x36, 0x7f, 0xff,
		0xdd, 0x36, 0x7f, 0xff,
		0xdd, 0x36, 0x80, 0xff,
		0xdd, 0x36, 0x80, 0xff,
		0xdd, 0x36, 0x80, 0xff,
));

z80asm_nok("", "", <<END, <<END);
		im -1
		im 3
		
		call_oz 0
END
$test.asm:1: error: integer range: -1
  ^---- im -1
$test.asm:2: error: integer range: 3
  ^---- im 3
$test.asm:4: error: integer range: 0
  ^---- call_oz 0
END

for my $op (qw(bit res set)) {
	for my $bit (-1, 8) {
		for my $reg (qw(b c d e h l a)) {
			z80asm_nok("", "", <<END, <<END);
				$op $bit, $reg
END
$test.asm:1: error: integer range: $bit
  ^---- $op $bit, $reg
END
		}
	}
}
			
#------------------------------------------------------------------------------
# JR / DJNZ
#------------------------------------------------------------------------------
for ([jr => 0x18], [djnz => 0x10]) {
	my($jump, $opcode) = @$_;

	z80asm_nok("", "", "$jump ASMPC+2-129", <<END);
$test.asm:1: error: integer range: -129
  ^---- \$+2-129
END

	z80asm_nok("", "", "$jump label \n defc label = ASMPC-129", <<END);
$test.asm:1: error: integer range: -129
  ^---- label
END

	z80asm_nok("", "", "$jump ASMPC+2+128", <<END);
$test.asm:1: error: integer range: 0x80
  ^---- \$+2+128
END

	z80asm_nok("", "", "$jump label \n defc label = ASMPC+128", <<END);
$test.asm:1: error: integer range: 0x80
  ^---- label
END

	for my $org (0, 0x8000, 0xFFFE) {
		z80asm_ok("", "", "", <<END, bytes($opcode, 0x80));
			org $org
			$jump ASMPC+2-128
END

		z80asm_ok("", "", "", <<END, bytes($opcode, 0x80));
			org $org
			$jump label 
			defc label = ASMPC-128
END

		z80asm_ok("", "", "", <<END, bytes($opcode, 0x7f));
			org $org
			$jump ASMPC+2+127
END

		z80asm_ok("", "", "", <<END, bytes($opcode, 0x7f));
			org $org
			$jump label
			defc label = ASMPC+127
END
	}
}

#------------------------------------------------------------------------------
# error_unbanlanced_paren
#------------------------------------------------------------------------------
z80asm_ok("", "", "", "ld a,2*(1+2)", bytes(0x3e, 6));
z80asm_ok("", "", "", "ld a,2*[1+2]", bytes(0x3e, 6));

z80asm_nok("", "", "ld a,2*(1+2", <<END);
$test.asm:1: error: syntax error in expression
  ^---- ld a,2*(1+2
END

z80asm_nok("", "", "ld a,2*(1+2]", <<END);
$test.asm:1: error: syntax error in expression
  ^---- ld a,2*(1+2]
END

z80asm_nok("", "", "ld a,2*[1+2", <<END);
$test.asm:1: error: syntax error in expression
  ^---- ld a,2*[1+2
END

z80asm_nok("", "", "ld a,2*[1+2)", <<END);
$test.asm:1: error: syntax error in expression
  ^---- ld a,2*[1+2)
END

#------------------------------------------------------------------------------
# undefined symbol
#------------------------------------------------------------------------------
z80asm_nok("", "", "ld a,NOSYMBOL", <<END);
$test.asm:1: error: undefined symbol: NOSYMBOL
  ^---- NOSYMBOL
END

spew("$test.asm", <<END);
		main: ret
END
run_ok("z88dk-z80asm -x$test.lib $test.asm");
z80asm_nok("-b -l$test.lib", "", <<END_ASM, <<END_ERR);
		EXTERN main
		call main
END_ASM
$test.asm:2: error: undefined symbol: main
  ^---- main
END_ERR

#------------------------------------------------------------------------------
# options
#------------------------------------------------------------------------------
capture_nok("z88dk-z80asm -b", <<END);
error: source file expected
END

spew("$test.asm", "");
capture_nok("z88dk-z80asm -Zillegaloption $test.asm", <<END);
error: illegal option: -Zillegaloption
END

spew("$test.asm", "");
capture_nok("z88dk-z80asm +Zillegaloption $test.asm", <<END);
error: illegal option: +Zillegaloption
END

#------------------------------------------------------------------------------
# segment overflow
#------------------------------------------------------------------------------

# Assembler
z80asm_ok("", "", "", <<END, 'a' x 65536);
		defs 65535, 'a'
		defm "a"
END

z80asm_nok("", "", <<END, <<END);
		defs 65536, 'a'
		defm "a"
END
$test.asm:2: error: segment overflow
  ^---- defm "a"
END

# Linker
spew("$test.1.asm", <<END);
		defb 0xAA
END

spew("$test.asm", <<END);
		defs 65535, 0xAA
END

run_ok("z88dk-z80asm -b $test.asm $test.1.asm");
check_bin_file("$test.bin", bytes(0xAA) x 65536);

spew("$test.asm", <<END);
		defs 65536, 0xAA
END

run_ok("z88dk-z80asm $test.asm $test.1.asm");
unlink("$test.asm", "$test.1.asm");
capture_nok("z88dk-z80asm -b -d $test.o $test.1.o", <<END);
$test.1.o: error: segment overflow
END

#------------------------------------------------------------------------------
# error_jr_not_local
#------------------------------------------------------------------------------
spew("$test.asm", <<END);
		extern loop
		jr loop
END

spew("$test.1.asm", <<END);
		public loop
loop: 	ret
END

run_ok("z88dk-z80asm -b $test.asm $test.1.asm");
check_bin_file("$test.bin", bytes(0x18, 0x00, 0xc9));

#------------------------------------------------------------------------------
# error_obj_file_version
#------------------------------------------------------------------------------
$obj = objfile(NAME => "test", CODE => [["", -1, 1, "\x00"]] );
substr($obj,6,2) = "99";		# change version
spew("$test.o", $obj);
capture_nok("z88dk-z80asm -b $test.o", <<END);
$test.o: error: invalid object file version: file=$test.o, found=99, expected=16
END

#------------------------------------------------------------------------------
# error_lib_file_version
#------------------------------------------------------------------------------
my $lib = libfile(objfile(NAME => "test", CODE => [["", -1, 1, "\x00"]] ));
substr($lib,6,2) = "99";		# change version
spew("$test.lib", $lib);
spew("$test.asm", "nop");
capture_nok("z88dk-z80asm -b -l$test.lib $test.asm", <<END);
error: invalid library file version: file=$test.lib, found=99, expected=16
END

#------------------------------------------------------------------------------
# error_not_obj_file
#------------------------------------------------------------------------------
spew("$test.o", "not an object");
capture_nok("z88dk-z80asm -b $test.o", <<END);
$test.o: error: not an object file: $test.o
END

sleep 1;
spew("$test.asm", "nop");
run_ok("z88dk-z80asm -b -d $test.asm");
check_bin_file("$test.bin", bytes(0));

# CreateLib uses a different error call
spew("$test.o", "not an object");
sleep 1;
spew("$test.asm", "nop");
run_ok("z88dk-z80asm -x$test.lib -d $test.asm");
check_bin_file("$test.lib",
	libfile(objfile(NAME => $test,
				    CODE => [["", -1, 1, "\x00"]])));

spew("$test.o", 
	objfile(NAME => $test,
			CODE => [["", -1, 1, "\0\0"]],
			SYMBOLS => [ ["Z", "Z", "", 0, "ABCD", "", 0] ] ));
capture_nok("z88dk-z80asm -b -d $test.o", <<END);
$test.o: error: not an object file: $test.o
END

#------------------------------------------------------------------------------
# error_not_lib_file
#------------------------------------------------------------------------------
spew("$test.asm", "nop");
spew("$test.lib", "not a library");
capture_nok("z88dk-z80asm -b -l$test.lib $test.asm", <<END);
error: not a library file: $test.lib
END

#------------------------------------------------------------------------------
# warn_expr_in_parens
#------------------------------------------------------------------------------
z80asm_ok("", "", <<END, <<END, bytes(0xfe, 0x10));
$test.asm:1: warning: interpreting indirect value as immediate
  ^---- cp (16)
END
		cp (16)
END

z80asm_ok("", "", "", <<END, bytes(0xfe, 0x10));
		cp +(16)
END

#------------------------------------------------------------------------------
# error_expected_const_expr
#------------------------------------------------------------------------------
z80asm_nok("", "", <<END, <<END);
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
$test.asm:2: error: constant expression expected
  ^---- bit ZERO,a
$test.asm:3: error: constant expression expected
  ^---- set ZERO,a
$test.asm:4: error: constant expression expected
  ^---- res ZERO,a
$test.asm:5: error: constant expression expected
  ^---- im ZERO
$test.asm:6: error: constant expression expected
  ^---- rst ZERO
$test.asm:7: error: undefined symbol: undefined
  ^---- bit undefined,a
$test.asm:8: error: undefined symbol: undefined
  ^---- set undefined,a
$test.asm:9: error: undefined symbol: undefined
  ^---- res undefined,a
$test.asm:10: error: undefined symbol: undefined
  ^---- im undefined
$test.asm:10: error: constant expression expected
  ^---- im undefined
$test.asm:11: error: undefined symbol: undefined
  ^---- rst undefined
$test.asm:11: error: constant expression expected
  ^---- rst undefined
END

#------------------------------------------------------------------------------
# syntax errors
#------------------------------------------------------------------------------
z80asm_nok("", "", <<END, <<END);
		defb 1?
		defb 1?2
		defb 1?2:
		defb 1?2:1?
END
$test.asm:1: error: syntax error
  ^---- defb 1?
$test.asm:2: error: syntax error in expression
  ^---- defb 1?2
$test.asm:3: error: syntax error
  ^---- defb 1?2:
$test.asm:4: error: syntax error
  ^---- defb 1?2:1?
END

z80asm_nok("", "", <<END, <<END);
		defm "hello ",
		defm "hello "&
		defm "hello "&"world"
		defm "hello"&32&"world"
		defm 32,
END
$test.asm:1: error: syntax error
  ^---- defm "hello ",
$test.asm:2: error: syntax error
  ^---- defm "hello "&
$test.asm:3: error: syntax error
  ^---- defm "hello "&"world"
$test.asm:4: error: syntax error
  ^---- defm "hello"&32&"world"
$test.asm:5: error: syntax error
  ^---- defm 32,
END

#------------------------------------------------------------------------------
# illegal identifier
#------------------------------------------------------------------------------
for my $x (split(' ', "ix iy")) {
	for my $r1 (split(' ', "b c d e ${x}h ${x}l a")) {
		for my $r2 (split(' ', "${x}h ${x}l")) {
			ok 1, "ld $r1, $r2";
			z80asm_nok("-b -mr2ka", "", <<END, <<END);
				ld $r1, $r2
				ld $r2, $r1
				ld $r2, 1
END
$test.asm:1: error: illegal identifier
  ^---- ld $r1, $r2
$test.asm:2: error: illegal identifier
  ^---- ld $r2, $r1
$test.asm:3: error: illegal identifier
  ^---- ld $r2, 1
END
		}
	}
}

#------------------------------------------------------------------------------
# syntax error
#------------------------------------------------------------------------------
for my $r1 (split(' ', "b c d e h l (hl) (ix+3) (iy+3) 3")) {
	ok 1, "ld (bc), $r1";
	z80asm_nok("", "", <<END, <<END);
				ld (bc), $r1
END
$test.asm:1: error: syntax error
  ^---- ld (bc), $r1
END
}
		
unlink_testfiles;
done_testing;
