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

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/modlink.t,v 1.1 2014-06-21 02:15:44 pauloscustodio Exp $
#
# Test linking of modules

use Modern::Perl;
use t::TestZ80asm;

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
