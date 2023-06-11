#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# no ORG
z80asm_nok("", "", <<END_ASM, <<END_ERR);
		org
END_ASM
$test.asm:1: error: syntax error
  ^---- org
END_ERR

# ORG redefined
z80asm_nok("", "", <<END_ASM, <<END_ERR);
		org 0x1234
		org 0x5678
END_ASM
$test.asm:2: error: ORG redefined
  ^---- org 0x5678
      ^---- org 22136
END_ERR

# ORG not constant
z80asm_nok("", "", <<END_ASM, <<END_ERR);
		extern start
		org start
END_ASM
$test.asm:2: error: constant expression expected
  ^---- org start
END_ERR

# no ORG defined
z80asm_ok("", "", "", <<END, bytes(0xc3, 0, 0));
start:	jp start
END

# ORG defined
z80asm_ok("", "", "", <<END, bytes(0xc3, 0x34, 0x12));
		org 0x1234
start:	jp start
END

z80asm_ok("", "", "", <<END, bytes(0xc3, 0x34, 0x12));
		defc org = 0x1234
		org org
start:	jp start
END

# ORG in range
z80asm_ok("", "", "", <<END, bytes(0xc3, 0, 0));
		org 0
start:	jp start
END

z80asm_ok("", "", "", <<END, bytes(0xc3, 0, 0));
		org 0x10000
start:	jp start
END

z80asm_ok("", "", "", <<END, bytes(0xff));
		org 0xffff
		defb asmpc
END

z80asm_ok("", "", "", <<END, bytes(0xff));
		org 0xffff
		defb asmpc>>8
END

# ORG out of range
# Note: ORG -1 is split section
# Note: ORG can be set to address > 0xffff to allow for banked addresses
z80asm_nok("", "", <<END_ASM, <<END_ERR);
		org -2
END_ASM
$test.asm:1: error: integer range: -2
  ^---- org -2
END_ERR

# command line -r overrides ORG
for my $origin (0, 0x10000, 0x1234) {
	my $origin_hex = sprintf("%x", $origin);
	for my $origin_text ($origin, 
						 "0x${origin_hex}", "0X${origin_hex}", 
						 "0${origin_hex}h", "0${origin_hex}H", 
						 "\$${origin_hex}") {
		my $expected = bytes(0xc3, $origin & 0xff, ($origin >> 8) & 0xff);
		z80asm_ok("-b ".quote_os("-r$origin_text"), "", "", <<END, $expected);
				org 0x1000
		start:	jp start
END
	}
}

# command line range check
capture_nok("z88dk-z80asm -b -r-1", <<END);
error: invalid origin (-r) option: -1
END

capture_nok("z88dk-z80asm -b -r123Z", <<END);
error: invalid origin (-r) option: 123Z
END

# BUG_0025 : JR at org 0 with out-of-range jump crashes WriteListFile()
z80asm_nok("", "", <<END_ASM, <<END_ERR);
		jr ASMPC+2-129
END_ASM
$test.asm:1: error: integer range: -\$81
  ^---- \$+2-129
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		jr ASMPC+2+128
END_ASM
$test.asm:1: error: integer range: \$80
  ^---- \$+2+128
END_ERR

# -split-bin, ORG -1
unlink_testfiles;
spew("$test.asm", <<END);
	defw ASMPC
	
	section code
	defw ASMPC
	
	section data
	defw ASMPC
	
	section bss		; split file here
	org 0x4000
	defw ASMPC
END
run_ok("z88dk-z80asm -b $test.asm");
check_bin_file("${test}.bin", 		words(0, 2, 4));
ok ! -f "${test}_code.bin", "${test}_code.bin";
ok ! -f "${test}_data.bin", "${test}_data.bin";
check_bin_file("${test}_bss.bin",	words(0x4000));

unlink_testfiles;
spew("$test.asm", <<END);
	defw ASMPC		; split file here
	
	section code	; split file here
	defw ASMPC
	
	section data	; split file here
	defw ASMPC
	
	section bss		; split file here
	org 0x4000
	defw ASMPC
END
run_ok("z88dk-z80asm -b -split-bin $test.asm");
check_bin_file("${test}.bin", 		words(0));
check_bin_file("${test}_code.bin", 	words(2));
check_bin_file("${test}_data.bin", 	words(4));
check_bin_file("${test}_bss.bin", 	words(0x4000));

unlink_testfiles;
spew("$test.asm", <<END);
	defw ASMPC
	
	section code
	defw ASMPC
	
	section data	; split file here
	org 0x4000
	defw ASMPC
	
	section bss		; split file here
	org -1
	defw ASMPC
END
run_ok("z88dk-z80asm -b $test.asm");
check_bin_file("${test}.bin", 		words(0, 2));
ok ! -f "${test}_code.bin", "${test}_code.bin";
check_bin_file("${test}_data.bin", 	words(0x4000));
check_bin_file("${test}_bss.bin", 	words(0x4002));

unlink_testfiles;
done_testing;
