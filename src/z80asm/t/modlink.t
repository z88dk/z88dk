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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/modlink.t,v 1.3 2014-06-26 21:33:24 pauloscustodio Exp $
#
# Test linking of modules

use Modern::Perl;
use t::TestZ80asm;

#------------------------------------------------------------------------------
# test with z80nm
#------------------------------------------------------------------------------
system("make -C ../../support/ar") and die;
sub t_z80nm {
	my($obj_file, $expected_out) = @_;
	unless ( get_legacy() ) {			# don't test old object file format
		my $line = "[line ".((caller)[2])."]";
		my($stdout, $stderr, $return) = capture {
			system "../../support/ar/z80nm -a $obj_file";
		};
		eq_or_diff_text $stdout, $expected_out, "$line stdout";
		eq_or_diff_text $stderr, "", "$line stderr";
		ok !!$return == !!0, "$line retval";
	}
}

#------------------------------------------------------------------------------
# Test expressions across modules
z80asm(
	asm =>	<<'ASM',
			org $1234
			
			public a1
			extern a2, ASMHEAD, ASMTAIL, ASMSIZE
			
			ld	a, ASMPC -$1200	;$1234 ;; 3E 34
			jp	ASMPC			;$1236 ;; C3 36 12
			ld	b, a1 -$1200	;$1239 ;; 06 47
			jp	a1				;$123B ;; C3 47 12
			ld	hl, a2 - a1		;$123E ;; 21 1C 00
			ld	bc, a1 - ASMPC	;$1241 ;; 01 06 00
			ld	de, a2 - ASMPC	;$1244 ;; 11 1F 00
	a1:							;$1247
			ld	hl, ASMHEAD		;$1247 ;; 21 34 12
			ld	de, ASMTAIL		;$124A ;; 11 6C 12
			ld	bc, ASMSIZE		;$124D ;; 01 38 00
								;$1250
ASM
	asm1 => <<'ASM1',
			public a2
			extern a1, ASMHEAD, ASMTAIL, ASMSIZE
			
			ld	a, ASMPC -$1200	;$1250 ;; 3E 50
			jp	ASMPC			;$1252 ;; C3 52 12
			ld	b, a2 -$1200	;$1255 ;; 06 63
			jp	a2				;$1257 ;; C3 63 12
			ld	hl, a2 - a1		;$125A ;; 21 1C 00
			ld	bc, ASMPC - a1	;$125D ;; 01 16 00
			ld	de, a2 - ASMPC	;$1260 ;; 11 03 00
	a2:							;$1263
			ld	hl, ASMHEAD		;$1263 ;; 21 34 12
			ld	de, ASMTAIL		;$1266 ;; 11 6C 12
			ld	bc, ASMSIZE		;$1269 ;; 01 38 00
								;$126C
ASM1
	options => "-b -l"
);
my $bin = read_binfile("test.bin");

# link only
z80asm(
	options => "-d -b test.obj test1.obj",
	bin		=> $bin,
);

t_z80nm("test.obj test1.obj", <<'END');

File test.obj at $0000: Z80RMF05
  Name: test
  Org:  $1234
  Names:
    G A $0013 a1 (section '')
  External names:
    U         a2
    U         ASMHEAD
    U         ASMTAIL
    U         ASMSIZE
  Expressions:
    E Ub (test.asm:6) $0000 $0001: ASMPC-4608 (section '')
    E Cw (test.asm:7) $0002 $0003: ASMPC (section '')
    E Ub (test.asm:8) $0005 $0006: a1-4608 (section '')
    E Cw (test.asm:9) $0007 $0008: a1 (section '')
    E Cw (test.asm:10) $000A $000B: a2-a1 (section '')
    E Cw (test.asm:11) $000D $000E: a1-ASMPC (section '')
    E Cw (test.asm:12) $0010 $0011: a2-ASMPC (section '')
    E Cw (test.asm:14) $0013 $0014: ASMHEAD (section '')
    E Cw (test.asm:15) $0016 $0017: ASMTAIL (section '')
    E Cw (test.asm:16) $0019 $001A: ASMSIZE (section '')
  Code: 28 bytes (section '')
    C $0000: 3E 00 C3 00 00 06 00 C3 00 00 21 00 00 01 00 00
    C $0010: 11 00 00 21 00 00 11 00 00 01 00 00

File test1.obj at $0000: Z80RMF05
  Name: test1
  Names:
    G A $0013 a2 (section '')
  External names:
    U         a1
    U         ASMHEAD
    U         ASMTAIL
    U         ASMSIZE
  Expressions:
    E Ub (test1.asm:4) $0000 $0001: ASMPC-4608 (section '')
    E Cw (test1.asm:5) $0002 $0003: ASMPC (section '')
    E Ub (test1.asm:6) $0005 $0006: a2-4608 (section '')
    E Cw (test1.asm:7) $0007 $0008: a2 (section '')
    E Cw (test1.asm:8) $000A $000B: a2-a1 (section '')
    E Cw (test1.asm:9) $000D $000E: ASMPC-a1 (section '')
    E Cw (test1.asm:10) $0010 $0011: a2-ASMPC (section '')
    E Cw (test1.asm:12) $0013 $0014: ASMHEAD (section '')
    E Cw (test1.asm:13) $0016 $0017: ASMTAIL (section '')
    E Cw (test1.asm:14) $0019 $001A: ASMSIZE (section '')
  Code: 28 bytes (section '')
    C $0000: 3E 00 C3 00 00 06 00 C3 00 00 21 00 00 01 00 00
    C $0010: 11 00 00 21 00 00 11 00 00 01 00 00
END

eq_or_diff scalar(read_file("test.map")), <<'END';
a1                              = 1247, G: test
a2                              = 1263, G: test1
ASMHEAD                         = 1234, G: 
ASMSIZE                         = 0038, G: 
ASMTAIL                         = 126C, G: 


ASMSIZE                         = 0038, G: 
ASMHEAD                         = 1234, G: 
a1                              = 1247, G: test
a2                              = 1263, G: test1
ASMTAIL                         = 126C, G: 
END

#------------------------------------------------------------------------------
# Test sections
my $expect_bin = pack("C*", 
					0x21, 0x59, 0x12, 
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
				"hello".
				" world".
				".";
					
z80asm(
	asm =>	<<'ASM',
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
ASM
	asm1 => <<'ASM1',
	
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
			
ASM1
	options => "-b -l",
	bin		=> $expect_bin,
);

# link only
z80asm(
	options => "-d -b test.obj test1.obj",
	bin		=> $expect_bin,
);

t_z80nm("test.obj test1.obj", <<'END');

File test.obj at $0000: Z80RMF05
  Name: test
  Org:  $1234
  Names:
    L A $0000 start (section 'code')
    L A $0000 mes1 (section 'data')
    L A $0005 mes1end (section 'data')
    L A $0005 mes2 (section 'data')
    L A $000B mes2end (section 'data')
  External names:
    U         prmes
    U         mes0
    U         mes0end
  Expressions:
    E Cw (test.asm:6) $0000 $0001: mes1 (section 'code')
    E Cw (test.asm:7) $0003 $0004: mes1end-mes1 (section 'code')
    E Cw (test.asm:13) $0006 $0007: prmes (section 'code')
    E Cw (test.asm:16) $0009 $000A: mes2 (section 'code')
    E Cw (test.asm:17) $000C $000D: mes2end-mes2 (section 'code')
    E Cw (test.asm:23) $000F $0010: prmes (section 'code')
    E Cw (test.asm:25) $0012 $0013: mes0 (section 'code')
    E Cw (test.asm:26) $0015 $0016: mes0end-mes0 (section 'code')
    E Cw (test.asm:27) $0018 $0019: prmes (section 'code')
  Code: 28 bytes (section 'code')
    C $0000: 21 00 00 01 00 00 CD 00 00 21 00 00 01 00 00 CD
    C $0010: 00 00 21 00 00 01 00 00 CD 00 00 C9
  Code: 11 bytes (section 'data')
    C $0000: 68 65 6C 6C 6F 20 77 6F 72 6C 64

File test1.obj at $0000: Z80RMF05
  Name: test1
  Names:
    G A $0000 prmes (section 'code')
    G A $0000 mes0 (section 'data')
    G A $0001 mes0end (section 'data')
  Code: 9 bytes (section 'code')
    C $0000: 78 B1 C8 7E 23 D7 0B 18 F7
  Code: 1 bytes (section 'data')
    C $0000: 2E
END

eq_or_diff scalar(read_file("test.map")), <<'END';
ASMHEAD                         = 1234, G: 
ASMHEAD_code                    = 1234, G: 
ASMHEAD_data                    = 1259, G: 
ASMSIZE                         = 0031, G: 
ASMSIZE_code                    = 0025, G: 
ASMSIZE_data                    = 000C, G: 
ASMTAIL                         = 1265, G: 
ASMTAIL_code                    = 1259, G: 
ASMTAIL_data                    = 1265, G: 
mes0                            = 1264, G: test1
mes0end                         = 1265, G: test1
mes1                            = 1259, L: test
mes1end                         = 125E, L: test
mes2                            = 125E, L: test
mes2end                         = 1264, L: test
prmes                           = 1250, G: test1
start                           = 1234, L: test


ASMSIZE_data                    = 000C, G: 
ASMSIZE_code                    = 0025, G: 
ASMSIZE                         = 0031, G: 
ASMHEAD                         = 1234, G: 
ASMHEAD_code                    = 1234, G: 
start                           = 1234, L: test
prmes                           = 1250, G: test1
ASMHEAD_data                    = 1259, G: 
ASMTAIL_code                    = 1259, G: 
mes1                            = 1259, L: test
mes1end                         = 125E, L: test
mes2                            = 125E, L: test
mes0                            = 1264, G: test1
mes2end                         = 1264, L: test
ASMTAIL                         = 1265, G: 
ASMTAIL_data                    = 1265, G: 
mes0end                         = 1265, G: test1
END
