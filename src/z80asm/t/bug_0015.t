#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# BUG_0015: Relocation issue - dubious addresses come out of linking
spew("$test.asm", <<END);
				PUBLIC L1

	    L1:		ld l,1		; 802C  2E 01
				jp L2		; 802E  C3 31 80

	    L2:		ld l,2		; 8031  2E 02
				jp L1		; 8033  C3 2C 80
							; 8036
END

run_ok("z88dk-z80asm -x$test.lib $test.asm");

spew("$test.1.asm", <<END);
				PUBLIC A1, A2
				EXTERN B1, B2, L1

	    A1:		ld a,1		; 8000 ;; 3E 01
				call B1		; 8002 ;; CD 16 80
				call L1		; 8005 ;; CD 2C 80
				jp A2		; 8008 ;; C3 0B 80

	    A2:		ld a,2		; 800B ;; 3E 02
				call B2		; 800D ;; CD 21 80
				call L1		; 8010 ;; CD 2C 80
				jp A1		; 8013 ;; C3 00 80
							; 8016
END

spew("$test.2.asm", <<END);
				PUBLIC B1, B2
				EXTERN A1, A2, L1

	    B1:		ld b,1		; 8016 ;; 06 01
				call A1		; 8018 ;; CD 00 80
				call L1		; 801B ;; CD 2C 80
				jp B2		; 801E ;; C3 21 80

	    B2:		ld b,2		; 8021 ;; 06 02
				call A2		; 8023 ;; CD 0B 80
				call L1		; 8026 ;; CD 2C 80
				jp B1		; 8029 ;; C3 16 80
							; 802C ;; 2E 01
							; 802E ;; C3 31 80
							; 8031 ;; 2E 02
							; 8033 ;; C3 2C 80
							; 8036
END

run_ok("z88dk-z80asm -l$test.lib -b -r0x8000 -o$test.bin $test.1.asm $test.2.asm");

check_bin_file("$test.bin", bytes(0x3e, 0x01,
								  0xcd, 0x16, 0x80,
								  0xcd, 0x2c, 0x80,
								  0xc3, 0x0b, 0x80,
								  0x3e, 0x02,
								  0xcd, 0x21, 0x80,
								  0xcd, 0x2c, 0x80,
								  0xc3, 0x00, 0x80,
								  0x06, 0x01,
								  0xcd, 0x00, 0x80,
								  0xcd, 0x2c, 0x80,
								  0xc3, 0x21, 0x80,
								  0x06, 0x02,
								  0xcd, 0x0b, 0x80,
								  0xcd, 0x2c, 0x80,
								  0xc3, 0x16, 0x80,
								  0x2e, 0x01,
								  0xc3, 0x31, 0x80,
								  0x2e, 0x02,
								  0xc3, 0x2c, 0x80,
));

unlink_testfiles;
done_testing;
