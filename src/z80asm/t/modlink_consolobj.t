#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

#------------------------------------------------------------------------------
# Test consolidated object file

unlink_testfiles;

spew("${test}1.asm", <<'END');
		global main, main1, print, lib_start, lib_end

		section code
	main:
		call lib_start
		ld hl,mess
		call print
		call lib_end
		ret

		section data
	mess: defb "hello "

		defc main1 = main
END

spew("${test}2.asm", <<'END');
		global print, print1, printa

		defc print = print1
		defc printa1 = printa

		section code
	printa:
		ld a,(hl)
		and a
		ret z
		rst 10h
		inc hl
		call _delay
		jp printa1

	_delay:
		ld b,0
	_delay_1:
		dec b
		jp nz, _delay_1
		ret

		section data
	mess: defb "world"
END

spew("${test}3.asm", <<'END');
		global print1, printa

		section code
	print1:
		push hl
		call printa
		pop hl
		ret

		section data
	mess: defb "!", 0
	dollar:	defw ASMPC
END

spew("${test}4.asm", <<'END');
		global code_end

		section code
	code_end:
END

spew("${test}lib.asm", <<'END');
		global lib_start, lib_end

		defc lib_start = 0
		defc lib_end   = 0
END

sub bincode {
	my($addr) = @_;
	my $code;
	my $data;
	my $l_main = 0;
	my $l_print = 0;
	my $l_print1 = 0;
	my $l_printa = 0;
	my $l_mess = 0;
	my $l_dollar = 0;
	my $l_delay = 0;
	my $l_delay1 = 0;

	for my $pass (1..2) {
		$code = "";
		$data = "";

		# test1.asm
		$l_main = $addr + length($code);
		$code .= pack("Cv", 0xCD, 0).
				 pack("Cv", 0x21, $l_mess).
				 pack("Cv", 0xCD, $l_print).
				 pack("Cv", 0xCD, 0).
				 pack("C",  0xC9);

		$data .= "hello ";

		# test2.asm
		$l_printa = $addr + length($code);
		$code .= pack("C*",	0x7E,
							0xA7,
							0xC8,
							0xD7,
							0x23).
				 pack("Cv",	0xCD, $l_delay).
				 pack("Cv",	0xC3, $l_printa);

		$l_delay = $addr + length($code);
		$code .= pack("C*",	0x06, 0x00);

		$l_delay1 = $addr + length($code);
		$code .= pack("C*",	0x05).
				 pack("Cv",	0xC2, $l_delay1).
				 pack("C*",	0xC9);

		$data .= "world";

		# test3.asm
		$l_print1 = $addr + length($code);
		$code .= pack("C*",	0xE5).
				 pack("Cv",	0xCD, $l_printa).
				 pack("C*",	0xE1,
							0xC9);

		$data .= "!\0";
		$data .= pack("v", $l_dollar);

		if ($pass == 1) {
			$l_mess = $addr + length($code);
			$l_dollar = $addr + length($code) + length($data) - 2;
			$l_print = $l_print1;
		}
	}

	my $bin = $code.$data;
	return $bin;
};

# build consolidated object file
capture_ok("z88dk-z80asm -s -o${test}.o ".
		   "${test}1.asm ${test}2.asm ${test}3.asm ${test}4.asm", "");

capture_ok("z88dk-z80nm -a ${test}.o", <<END);
Object  file ${test}.o at \$0000: Z80RMF16
  Name: ${test}
  Section code: 37 bytes
    C \$0000: CD 00 00 21 00 00 CD 00 00 CD 00 00 C9 7E A7 C8
    C \$0010: D7 23 CD 00 00 C3 00 00 06 00 05 C2 00 00 C9 E5
    C \$0020: CD 00 00 E1 C9
  Section data: 15 bytes
    C \$0000: 68 65 6C 6C 6F 20 77 6F 72 6C 64 21 00 00 00
  Symbols:
    L A \$0000 ${test}1_mess (section data) (file ${test}1.asm:12)
    L = \$0000 ${test}2_printa1 (section "") (file ${test}2.asm:4)
    L A \$0018 ${test}2__delay (section code) (file ${test}2.asm:16)
    L A \$001A ${test}2__delay_1 (section code) (file ${test}2.asm:18)
    L A \$0006 ${test}2_mess (section data) (file ${test}2.asm:24)
    L A \$000B ${test}3_mess (section data) (file ${test}3.asm:11)
    L A \$000D ${test}3_dollar (section data) (file ${test}3.asm:12)
    G A \$0000 main (section code) (file ${test}1.asm:4)
    G = \$0000 main1 (section data) (file ${test}1.asm:14)
    G = \$0000 print (section "") (file ${test}2.asm:3)
    G A \$000D printa (section code) (file ${test}2.asm:7)
    G A \$001F print1 (section code) (file ${test}3.asm:4)
    G A \$0025 code_end (section code) (file ${test}4.asm:4)
  Externs:
    U         lib_start
    U         lib_end
  Expressions:
    E Cw \$0000 \$0001: lib_start (section code) (file ${test}1.asm:5)
    E Cw \$0003 \$0004: ${test}1_mess (section code) (file ${test}1.asm:6)
    E Cw \$0006 \$0007: print (section code) (file ${test}1.asm:7)
    E Cw \$0009 \$000A: lib_end (section code) (file ${test}1.asm:8)
    E =  \$0006 \$0006: main1 := main (section data) (file ${test}1.asm:14)
    E Cw \$001B \$001C: ${test}2__delay_1 (section code) (file ${test}2.asm:20)
    E Cw \$0015 \$0016: ${test}2_printa1 (section code) (file ${test}2.asm:14)
    E Cw \$0012 \$0013: ${test}2__delay (section code) (file ${test}2.asm:13)
    E =  \$0000 \$0000: ${test}2_printa1 := printa (section "") (file ${test}2.asm:4)
    E =  \$0000 \$0000: print := print1 (section "") (file ${test}2.asm:3)
    E Cw \$000D \$000D: \$ (section data) (file ${test}3.asm:12)
    E Cw \$0020 \$0021: printa (section code) (file ${test}3.asm:6)
END

check_text_file("${test}.sym", <<'END');
test_t_modlink_consolobj1_mess  = $0000 ; addr, local, , , data, test_t_modlink_consolobj1.asm:12
test_t_modlink_consolobj2_printa1 = $0000 ; comput, local, , , , test_t_modlink_consolobj2.asm:4
test_t_modlink_consolobj2__delay = $0018 ; addr, local, , , code, test_t_modlink_consolobj2.asm:16
test_t_modlink_consolobj2__delay_1 = $001A ; addr, local, , , code, test_t_modlink_consolobj2.asm:18
test_t_modlink_consolobj2_mess  = $0006 ; addr, local, , , data, test_t_modlink_consolobj2.asm:24
test_t_modlink_consolobj3_mess  = $000B ; addr, local, , , data, test_t_modlink_consolobj3.asm:11
test_t_modlink_consolobj3_dollar = $000D ; addr, local, , , data, test_t_modlink_consolobj3.asm:12
main                            = $0000 ; addr, public, , , code, test_t_modlink_consolobj1.asm:4
main1                           = $0000 ; comput, public, , , data, test_t_modlink_consolobj1.asm:14
print                           = $0000 ; comput, public, , , , test_t_modlink_consolobj2.asm:3
printa                          = $000D ; addr, public, , , code, test_t_modlink_consolobj2.asm:7
print1                          = $001F ; addr, public, , , code, test_t_modlink_consolobj3.asm:4
code_end                        = $0025 ; addr, public, , , code, test_t_modlink_consolobj4.asm:4
END


# build at address 0
unlink("${test}.asm", "${test}.bin");
capture_ok("z88dk-z80asm -b -m ${test}.o ${test}lib.asm", "");
check_bin_file("${test}.bin", bincode(0));

check_text_file("${test}.map", <<'END');
test_t_modlink_consolobj1_mess  = $0025 ; addr, local, , test_t_modlink_consolobj, data, test_t_modlink_consolobj1.asm:12
test_t_modlink_consolobj2_printa1 = $000D ; addr, local, , test_t_modlink_consolobj, , test_t_modlink_consolobj2.asm:4
test_t_modlink_consolobj2__delay = $0018 ; addr, local, , test_t_modlink_consolobj, code, test_t_modlink_consolobj2.asm:16
test_t_modlink_consolobj2__delay_1 = $001A ; addr, local, , test_t_modlink_consolobj, code, test_t_modlink_consolobj2.asm:18
test_t_modlink_consolobj2_mess  = $002B ; addr, local, , test_t_modlink_consolobj, data, test_t_modlink_consolobj2.asm:24
test_t_modlink_consolobj3_mess  = $0030 ; addr, local, , test_t_modlink_consolobj, data, test_t_modlink_consolobj3.asm:11
test_t_modlink_consolobj3_dollar = $0032 ; addr, local, , test_t_modlink_consolobj, data, test_t_modlink_consolobj3.asm:12
main                            = $0000 ; addr, public, , test_t_modlink_consolobj, code, test_t_modlink_consolobj1.asm:4
main1                           = $0000 ; addr, public, , test_t_modlink_consolobj, data, test_t_modlink_consolobj1.asm:14
print                           = $001F ; addr, public, , test_t_modlink_consolobj, , test_t_modlink_consolobj2.asm:3
printa                          = $000D ; addr, public, , test_t_modlink_consolobj, code, test_t_modlink_consolobj2.asm:7
print1                          = $001F ; addr, public, , test_t_modlink_consolobj, code, test_t_modlink_consolobj3.asm:4
code_end                        = $0025 ; addr, public, , test_t_modlink_consolobj, code, test_t_modlink_consolobj4.asm:4
lib_start                       = $0000 ; const, public, , test_t_modlink_consolobjlib, , test_t_modlink_consolobjlib.asm:3
lib_end                         = $0000 ; const, public, , test_t_modlink_consolobjlib, , test_t_modlink_consolobjlib.asm:4
__head                          = $0000 ; const, public, def, , ,
__tail                          = $0034 ; const, public, def, , ,
__size                          = $0034 ; const, public, def, , ,
__code_head                     = $0000 ; const, public, def, , ,
__code_tail                     = $0025 ; const, public, def, , ,
__code_size                     = $0025 ; const, public, def, , ,
__data_head                     = $0025 ; const, public, def, , ,
__data_tail                     = $0034 ; const, public, def, , ,
__data_size                     = $000F ; const, public, def, , ,
END


# build at address 0x1234
unlink("${test}.asm", "${test}.bin");
capture_ok("z88dk-z80asm -r0x1234 -b -m ${test}.o ${test}lib.asm", "");
check_bin_file("${test}.bin", bincode(0x1234));

check_text_file("${test}.map", <<'END');
test_t_modlink_consolobj1_mess  = $1259 ; addr, local, , test_t_modlink_consolobj, data, test_t_modlink_consolobj1.asm:12
test_t_modlink_consolobj2_printa1 = $1241 ; addr, local, , test_t_modlink_consolobj, , test_t_modlink_consolobj2.asm:4
test_t_modlink_consolobj2__delay = $124C ; addr, local, , test_t_modlink_consolobj, code, test_t_modlink_consolobj2.asm:16
test_t_modlink_consolobj2__delay_1 = $124E ; addr, local, , test_t_modlink_consolobj, code, test_t_modlink_consolobj2.asm:18
test_t_modlink_consolobj2_mess  = $125F ; addr, local, , test_t_modlink_consolobj, data, test_t_modlink_consolobj2.asm:24
test_t_modlink_consolobj3_mess  = $1264 ; addr, local, , test_t_modlink_consolobj, data, test_t_modlink_consolobj3.asm:11
test_t_modlink_consolobj3_dollar = $1266 ; addr, local, , test_t_modlink_consolobj, data, test_t_modlink_consolobj3.asm:12
main                            = $1234 ; addr, public, , test_t_modlink_consolobj, code, test_t_modlink_consolobj1.asm:4
main1                           = $1234 ; addr, public, , test_t_modlink_consolobj, data, test_t_modlink_consolobj1.asm:14
print                           = $1253 ; addr, public, , test_t_modlink_consolobj, , test_t_modlink_consolobj2.asm:3
printa                          = $1241 ; addr, public, , test_t_modlink_consolobj, code, test_t_modlink_consolobj2.asm:7
print1                          = $1253 ; addr, public, , test_t_modlink_consolobj, code, test_t_modlink_consolobj3.asm:4
code_end                        = $1259 ; addr, public, , test_t_modlink_consolobj, code, test_t_modlink_consolobj4.asm:4
lib_start                       = $0000 ; const, public, , test_t_modlink_consolobjlib, , test_t_modlink_consolobjlib.asm:3
lib_end                         = $0000 ; const, public, , test_t_modlink_consolobjlib, , test_t_modlink_consolobjlib.asm:4
__head                          = $1234 ; const, public, def, , ,
__tail                          = $1268 ; const, public, def, , ,
__size                          = $0034 ; const, public, def, , ,
__code_head                     = $1234 ; const, public, def, , ,
__code_tail                     = $1259 ; const, public, def, , ,
__code_size                     = $0025 ; const, public, def, , ,
__data_head                     = $1259 ; const, public, def, , ,
__data_tail                     = $1268 ; const, public, def, , ,
__data_size                     = $000F ; const, public, def, , ,
END


unlink_testfiles;
done_testing;
