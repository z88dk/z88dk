#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

#------------------------------------------------------------------------------
# Test sections

spew("${test}.asm", <<'END');
			org $1234

			extern prmes, mes0, mes0end

			section code
start:		ld hl,mes1
			ld bc,mes1end - mes1

			section data
mes1:		defm "hello"
mes1end:
			section code
			call prmes

			section code
			ld hl,mes2
			ld bc,mes2end - mes2

			section data
mes2:		defm " world"
mes2end:
			section code
			call prmes

			ld hl,mes0
			ld bc,mes0end - mes0
			call prmes

			section code
			ret
END

spew("${test}1.asm", <<'END');
			section data
mes0:		defm "."
mes0end:

			section code
prmes:		ld 	a, b
			or 	c
			ret z

			ld 	a, (hl)
			inc	hl

			rst $10

			dec	bc
			jr 	prmes

			; declare public in a different section
			section data
			public prmes

			section code
			public mes0, mes0end
END

my $bin = bytes(0x21, 0x59, 0x12,
				0x01, 0x05, 0x00,
				0xCD, 0x50, 0x12,
				0x21, 0x5E, 0x12,
				0x01, 0x06, 0x00,
				0xCD, 0x50, 0x12,
				0x21, 0x64, 0x12,
				0x01, 0x01, 0x00,
				0xCD, 0x50, 0x12,
				0xC9,
				0x78,
				0xB1,
				0xC8,
				0x7E,
				0x23,
				0xD7,
				0x0B,
				0x18, 0xF7).
		"hello world.";

# assemble and link
unlink("${test}.bin");
capture_ok("z88dk-z80asm -b -l -m ${test}.asm ${test}1.asm", "");
check_bin_file("${test}.bin", $bin);

# link only
unlink("${test}.bin");
capture_ok("z88dk-z80asm -b -l -m ${test}.o ${test}1.o", "");
check_bin_file("${test}.bin", $bin);

capture_ok("z88dk-z80nm -a ${test}.o ${test}1.o", <<END);
Object  file ${test}.o at \$0000: Z80RMF18
  Name: ${test}
  CPU:  z80 
  Section "": 0 bytes, ORG \$1234
  Section code: 28 bytes
    C \$0000: 21 00 00 01 00 00 CD 00 00 21 00 00 01 00 00 CD
    C \$0010: 00 00 21 00 00 01 00 00 CD 00 00 C9
  Section data: 11 bytes
    C \$0000: 68 65 6C 6C 6F 20 77 6F 72 6C 64
  Symbols:
    L A \$0000: start (section code) (file ${test}.asm:6)
    L A \$0000: mes1 (section data) (file ${test}.asm:10)
    L A \$0005: mes1end (section data) (file ${test}.asm:11)
    L A \$0005: mes2 (section data) (file ${test}.asm:20)
    L A \$000B: mes2end (section data) (file ${test}.asm:21)
  Externs:
    U         prmes
    U         mes0
    U         mes0end
  Expressions:
    E W \$0000 \$0001 3: mes1 (section code) (file ${test}.asm:6)
    E W \$0003 \$0004 3: mes1end-mes1 (section code) (file ${test}.asm:7)
    E W \$0006 \$0007 3: prmes (section code) (file ${test}.asm:13)
    E W \$0009 \$000A 3: mes2 (section code) (file ${test}.asm:16)
    E W \$000C \$000D 3: mes2end-mes2 (section code) (file ${test}.asm:17)
    E W \$000F \$0010 3: prmes (section code) (file ${test}.asm:23)
    E W \$0012 \$0013 3: mes0 (section code) (file ${test}.asm:25)
    E W \$0015 \$0016 3: mes0end-mes0 (section code) (file ${test}.asm:26)
    E W \$0018 \$0019 3: prmes (section code) (file ${test}.asm:27)
Object  file ${test}1.o at \$0000: Z80RMF18
  Name: ${test}1
  CPU:  z80 
  Section "": 0 bytes, ORG \$1234
  Section code: 9 bytes
    C \$0000: 78 B1 C8 7E 23 D7 0B 18 F7
  Section data: 1 bytes
    C \$0000: 2E
  Symbols:
    G A \$0000: prmes (section code) (file ${test}1.asm:6)
    G A \$0000: mes0 (section data) (file ${test}1.asm:2)
    G A \$0001: mes0end (section data) (file ${test}1.asm:3)
END

check_text_file("${test}.map", <<END);
start                           = \$1234 ; addr, local, , ${test}, code, ${test}.asm:6
mes1                            = \$1259 ; addr, local, , ${test}, data, ${test}.asm:10
mes1end                         = \$125E ; addr, local, , ${test}, data, ${test}.asm:11
mes2                            = \$125E ; addr, local, , ${test}, data, ${test}.asm:20
mes2end                         = \$1264 ; addr, local, , ${test}, data, ${test}.asm:21
prmes                           = \$1250 ; addr, public, , ${test}1, code, ${test}1.asm:6
mes0                            = \$1264 ; addr, public, , ${test}1, data, ${test}1.asm:2
mes0end                         = \$1265 ; addr, public, , ${test}1, data, ${test}1.asm:3
__head                          = \$1234 ; const, public, def, , ,
__tail                          = \$1265 ; const, public, def, , ,
__size                          = \$0031 ; const, public, def, , ,
__code_head                     = \$1234 ; const, public, def, , ,
__code_tail                     = \$1259 ; const, public, def, , ,
__code_size                     = \$0025 ; const, public, def, , ,
__data_head                     = \$1259 ; const, public, def, , ,
__data_tail                     = \$1265 ; const, public, def, , ,
__data_size                     = \$000C ; const, public, def, , ,
END

#------------------------------------------------------------------------------
# Test empty sections

unlink_testfiles;

spew("${test}.asm", <<'END');
		section code
		section data
		section bss

		section bss
		defb 3
END

spew("${test}1.asm", <<'END');
		section code
		section data
		section bss

		section data
		defb 2
END

spew("${test}2.asm", <<'END');
		section code
		section data
		section bss

		section code
		defb 1
END

$bin = bytes(1, 2, 3);

# assemble and link
unlink("${test}.bin");
capture_ok("z88dk-z80asm -b -l -m ${test}.asm ${test}1.asm ${test}2.asm", "");
check_bin_file("${test}.bin", $bin);

# link only
unlink("${test}.bin");
capture_ok("z88dk-z80asm -b -l -m ${test}.o ${test}1.o ${test}2.o", "");
check_bin_file("${test}.bin", $bin);

capture_ok("z88dk-z80nm -a ${test}.o ${test}1.o ${test}2.o", <<END);
Object  file ${test}.o at \$0000: Z80RMF18
  Name: ${test}
  CPU:  z80 
  Section "": 0 bytes
  Section code: 0 bytes
  Section data: 0 bytes
  Section bss: 1 bytes
    C \$0000: 03
Object  file ${test}1.o at \$0000: Z80RMF18
  Name: ${test}1
  CPU:  z80 
  Section "": 0 bytes
  Section code: 0 bytes
  Section data: 1 bytes
    C \$0000: 02
  Section bss: 0 bytes
Object  file ${test}2.o at \$0000: Z80RMF18
  Name: ${test}2
  CPU:  z80 
  Section "": 0 bytes
  Section code: 1 bytes
    C \$0000: 01
  Section data: 0 bytes
  Section bss: 0 bytes
END


unlink_testfiles;
done_testing;
