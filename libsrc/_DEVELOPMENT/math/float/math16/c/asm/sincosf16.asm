;* * * * *  Small-C/Plus z88dk * * * * *
;  Version: 16606-fb6d348bb-20200630
;
;	Reconstructed for z80 Module Assembler
;
;	Module compile time: Sat Jul  4 00:15:55 2020


	C_LINE	0,"sincosf16.c"

	MODULE	sincosf16_c


	INCLUDE "z80_crt0.hdr"


	C_LINE	0,"math16.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	8,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	9,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	10,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	12,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	13,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	14,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	16,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	17,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	18,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	20,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	21,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	22,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	24,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	25,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	26,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	28,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	29,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	30,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	60,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	63,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	81,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	82,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	34,"math16.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	22,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	39,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	51,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	144,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	147,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	150,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	153,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	154,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	159,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	162,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	165,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	169,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	172,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	175,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	179,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	182,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	185,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	189,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	192,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	195,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	198,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	199,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	203,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	206,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	207,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	211,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	212,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	216,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	217,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	222,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	225,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	228,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	231,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	234,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	238,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	241,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	242,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	247,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	248,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	252,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	255,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	259,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	262,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	265,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	268,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	272,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	275,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	278,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	281,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	284,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	287,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	290,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	293,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	297,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	298,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	302,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	303,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	307,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	308,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	312,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	313,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	318,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	319,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	323,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	327,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	328,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	332,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	333,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	338,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	339,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	344,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	345,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	349,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	350,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	355,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	356,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	361,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	362,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	366,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	367,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	371,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	372,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	376,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	377,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	381,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	382,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	386,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	387,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	425,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	428,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	432,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	435,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	439,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	442,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	445,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	448,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	452,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	455,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	458,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	461,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	464,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	467,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	471,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	472,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	476,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	477,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	481,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	482,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	486,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	487,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	492,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	493,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	497,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	498,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	502,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	503,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	508,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	511,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	515,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	519,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	522,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	525,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	528,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	529,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	533,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	534,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	539,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	542,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	545,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	549,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	552,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	555,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	559,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	562,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	565,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	568,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	571,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	574,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	577,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	578,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	583,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	586,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	589,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	592,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	596,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	597,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	601,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	602,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	606,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	607,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	611,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	612,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	616,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	617,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	621,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	622,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	626,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	627,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	35,"math16.h"
	C_LINE	58,"sincosf16.c"
	C_LINE	60,"sincosf16.c"
	C_LINE	61,"sincosf16.c"
	C_LINE	63,"sincosf16.c"
	SECTION	code_compiler

; Function sinf16 flags 0x00000288 __smallc __z88dk_fastcall 
; _Float16 half_tsinf16(_Float16 xx)
; parameter '_Float16 xx' at 2 size(2)
	C_LINE	64,"sincosf16.c::sinf16"
.sinf16
	GLOBAL	_sinf16
._sinf16
	push	hl
	push	bc
	push	bc
	push	bc
	push	bc
	dec	sp
	ld	hl,0	;const
	add	hl,sp
	ld	(hl),+(1 % 256)
	ld	hl,7	;const
	add	hl,sp
	ex	de,hl
	ld	hl,9	;const
	add	hl,sp	;l_gintsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	ex	de,hl	;l_pint
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
	ld	hl,7	;const
	add	hl,sp	;l_gintspsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	hl
	ld	hl,0	;const
	call	l_f16_lt
	ld	a,h
	or	l
	jp	z,i_2
	ld	hl,0	;const
	add	hl,sp
	ld	(hl),+(65535 % 256)
	ld	hl,7	;const
	add	hl,sp
	push	hl
	ld	a,(hl)	;l_gint
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	a,h
	xor	128
	ld	h,a
	pop	de		;l_pint_pop
	ex	de,hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
.i_2
	ld	hl,1	;const
	add	hl,sp
	push	hl
	ld	hl,9	;const
	add	hl,sp	;l_gintspsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	hl
	ld	hl,14920	;const
	call	l_f16_mul
	call	l_f16_f2sint
	pop	de		;l_pint_pop
	ex	de,hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
	ld	hl,5	;const
	add	hl,sp
	push	hl
	ld	hl,3	;const
	add	hl,sp	;l_gintsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	call	l_f16_uint2f
	pop	de		;l_pint_pop
	ex	de,hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
	ld	hl,1	;const
	add	hl,sp	;l_gintsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	and	+(1 % 256)
	jp	z,i_4
	ld	hl,1	;const
	add	hl,sp
	inc	(hl)
	ld	a,(hl)
	inc	hl
	jr	nz,ASMPC+3
	inc	(hl)
	ld	hl,5	;const
	add	hl,sp
	push	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,15360	;const
	call	l_f16_add
	pop	de		;l_pint_pop
	ex	de,hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
.i_4
	ld	hl,1	;const
	add	hl,sp
	push	hl
	ld	a,(hl)
	and	+(7 % 256)
	ld	l,a
	ld	h,0
	pop	de		;l_pint_pop
	ex	de,hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
	ld	hl,1	;const
	add	hl,sp
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	hl,3
	and	a
	sbc	hl,de
	jp	nc,i_5
	ld	hl,0	;const
	add	hl,sp
	push	hl
	call	l_gchar
	call	l_neg
	pop	de
	ld	a,l
	ld	(de),a
	ld	hl,1	;const
	add	hl,sp
	push	hl
	ld	a,(hl)	;l_gint
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	bc,-4
	add	hl,bc
	pop	de		;l_pint_pop
	ex	de,hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
.i_5
	ld	hl,7	;const
	add	hl,sp
	push	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,9	;const
	add	hl,sp	;l_gintspsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	hl
	ld	hl,14920	;const
	call	l_f16_mul
	call	l_f16_sub
	pop	de		;l_pint_pop
	ex	de,hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
	ld	hl,3	;const
	add	hl,sp
	push	hl
	ld	hl,9	;const
	add	hl,sp	;l_gintspsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	hl
	ld	hl,11	;const
	add	hl,sp	;l_gintsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	call	l_f16_mul
	pop	de		;l_pint_pop
	ex	de,hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
	ld	hl,1	;const
	add	hl,sp	;l_gintsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	de,1
	and	a
	sbc	hl,de
	scf
	jr	z,ASMPC+3
	ccf
	jp	c,i_7
	ld	hl,1	;const
	add	hl,sp	;l_gintsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	de,2
	and	a
	sbc	hl,de
	jp	nz,i_6
.i_7
	ld	hl,5	;const
	add	hl,sp
	push	hl
	dec	hl
	dec	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,_f16_coeff_cos
	push	hl
	ld	hl,4	;const
	push	hl
	call	polyf16_callee
	push	hl
	ld	hl,7	;const
	add	hl,sp	;l_gintsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	a,-1
	call	l_f16_ldexp
	call	l_f16_sub
	push	hl
	ld	hl,15360	;const
	call	l_f16_add
	pop	de		;l_pint_pop
	ex	de,hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
	jp	i_10
.i_6
	ld	hl,5	;const
	add	hl,sp
	push	hl
	dec	hl
	dec	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,_f16_coeff_sin
	push	hl
	ld	hl,3	;const
	push	hl
	call	polyf16_callee
	push	hl
	ld	hl,11	;const
	add	hl,sp	;l_gintsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	call	l_f16_mul
	push	hl
	ld	hl,11	;const
	add	hl,sp	;l_gintsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	call	l_f16_add
	pop	de		;l_pint_pop
	ex	de,hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
.i_10
	ld	hl,0	;const
	call	l_gcharsp	;
	ld	a,l
	rla
	jp	nc,i_11
	ld	hl,5	;const
	add	hl,sp
	push	hl
	ld	a,(hl)	;l_gint
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	a,h
	xor	128
	ld	h,a
	pop	de		;l_pint_pop
	ex	de,hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
.i_11
	ld	hl,5	;const
	add	hl,sp	;l_gintsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	exx
	ld	hl,11	;const
	add	hl,sp
	ld	sp,hl
	exx
	ret


	C_LINE	125,"sincosf16.c::sinf16"

; Function cosf16 flags 0x00000288 __smallc __z88dk_fastcall 
; _Float16 half_tcosf16(_Float16 xx)
; parameter '_Float16 xx' at 2 size(2)
	C_LINE	126,"sincosf16.c::cosf16"
.cosf16
	GLOBAL	_cosf16
._cosf16
	push	hl
	push	bc
	push	bc
	push	bc
	push	bc
	dec	sp
	ld	hl,0	;const
	add	hl,sp
	ld	(hl),+(1 % 256)
	ld	hl,7	;const
	add	hl,sp
	ex	de,hl
	ld	hl,9	;const
	add	hl,sp	;l_gintsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	ex	de,hl	;l_pint
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
	ld	hl,7	;const
	add	hl,sp	;l_gintspsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	hl
	ld	hl,0	;const
	call	l_f16_lt
	ld	a,h
	or	l
	jp	z,i_12
	ld	hl,7	;const
	add	hl,sp
	push	hl
	ld	a,(hl)	;l_gint
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	a,h
	xor	128
	ld	h,a
	pop	de		;l_pint_pop
	ex	de,hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
.i_12
	ld	hl,1	;const
	add	hl,sp
	push	hl
	ld	hl,9	;const
	add	hl,sp	;l_gintspsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	hl
	ld	hl,14920	;const
	call	l_f16_mul
	call	l_f16_f2sint
	pop	de		;l_pint_pop
	ex	de,hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
	ld	hl,5	;const
	add	hl,sp
	push	hl
	ld	hl,3	;const
	add	hl,sp	;l_gintsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	call	l_f16_uint2f
	pop	de		;l_pint_pop
	ex	de,hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
	ld	hl,1	;const
	add	hl,sp	;l_gintsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	and	+(1 % 256)
	jp	z,i_13
	ld	hl,1	;const
	add	hl,sp
	inc	(hl)
	ld	a,(hl)
	inc	hl
	jr	nz,ASMPC+3
	inc	(hl)
	ld	hl,5	;const
	add	hl,sp
	push	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,15360	;const
	call	l_f16_add
	pop	de		;l_pint_pop
	ex	de,hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
.i_13
	ld	hl,1	;const
	add	hl,sp
	push	hl
	ld	a,(hl)
	and	+(7 % 256)
	ld	l,a
	ld	h,0
	pop	de		;l_pint_pop
	ex	de,hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
	ld	hl,1	;const
	add	hl,sp
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	hl,3
	and	a
	sbc	hl,de
	jp	nc,i_14
	ld	hl,1	;const
	add	hl,sp
	push	hl
	ld	a,(hl)	;l_gint
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	bc,-4
	add	hl,bc
	pop	de		;l_pint_pop
	ex	de,hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
	ld	hl,0	;const
	add	hl,sp
	push	hl
	call	l_gchar
	call	l_neg
	ld	a,l
	ld	l,a	;l_sxt
	rla
	sbc	a
	ld	h,a
	pop	de
	ld	a,l
	ld	(de),a
.i_14
	ld	hl,1	;const
	add	hl,sp
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	hl,1
	and	a
	sbc	hl,de
	jp	nc,i_15
	ld	hl,0	;const
	add	hl,sp
	push	hl
	call	l_gchar
	call	l_neg
	ld	a,l
	ld	l,a	;l_sxt
	rla
	sbc	a
	ld	h,a
	pop	de
	ld	a,l
	ld	(de),a
.i_15
	ld	hl,7	;const
	add	hl,sp
	push	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,9	;const
	add	hl,sp	;l_gintspsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	hl
	ld	hl,14920	;const
	call	l_f16_mul
	call	l_f16_sub
	pop	de		;l_pint_pop
	ex	de,hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
	ld	hl,3	;const
	add	hl,sp
	push	hl
	ld	hl,9	;const
	add	hl,sp	;l_gintspsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	hl
	ld	hl,11	;const
	add	hl,sp	;l_gintsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	call	l_f16_mul
	pop	de		;l_pint_pop
	ex	de,hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
	ld	hl,1	;const
	add	hl,sp	;l_gintsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	de,1
	and	a
	sbc	hl,de
	scf
	jr	z,ASMPC+3
	ccf
	jp	c,i_17
	ld	hl,1	;const
	add	hl,sp	;l_gintsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	de,2
	and	a
	sbc	hl,de
	jp	nz,i_16
.i_17
	ld	hl,5	;const
	add	hl,sp
	push	hl
	dec	hl
	dec	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,_f16_coeff_sin
	push	hl
	ld	hl,3	;const
	push	hl
	call	polyf16_callee
	push	hl
	ld	hl,11	;const
	add	hl,sp	;l_gintsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	call	l_f16_mul
	push	hl
	ld	hl,11	;const
	add	hl,sp	;l_gintsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	call	l_f16_add
	pop	de		;l_pint_pop
	ex	de,hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
	jp	i_19
.i_16
	ld	hl,5	;const
	add	hl,sp
	push	hl
	dec	hl
	dec	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	ld	hl,_f16_coeff_cos
	push	hl
	ld	hl,4	;const
	push	hl
	call	polyf16_callee
	push	hl
	ld	hl,7	;const
	add	hl,sp	;l_gintsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	a,-1
	call	l_f16_ldexp
	call	l_f16_sub
	push	hl
	ld	hl,15360	;const
	call	l_f16_add
	pop	de		;l_pint_pop
	ex	de,hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
.i_19
	ld	hl,0	;const
	call	l_gcharsp	;
	ld	a,l
	rla
	jp	nc,i_20
	ld	hl,5	;const
	add	hl,sp
	push	hl
	ld	a,(hl)	;l_gint
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	a,h
	xor	128
	ld	h,a
	pop	de		;l_pint_pop
	ex	de,hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
.i_20
	ld	hl,5	;const
	add	hl,sp	;l_gintsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	exx
	ld	hl,11	;const
	add	hl,sp
	ld	sp,hl
	exx
	ret



; --- Start of Static Variables ---

	SECTION	bss_compiler
	SECTION	code_compiler


; --- Start of Scope Defns ---

	GLOBAL	acos
	GLOBAL	asin
	GLOBAL	atan
	GLOBAL	atan2
	GLOBAL	atan2_callee
	GLOBAL	cos
	GLOBAL	sin
	GLOBAL	tan
	GLOBAL	acosh
	GLOBAL	asinh
	GLOBAL	atanh
	GLOBAL	cosh
	GLOBAL	sinh
	GLOBAL	tanh
	GLOBAL	exp
	GLOBAL	exp2
	GLOBAL	expm1
	GLOBAL	frexp
	GLOBAL	frexp_callee
	GLOBAL	ilogb
	GLOBAL	ldexp
	GLOBAL	ldexp_callee
	GLOBAL	scalbn
	GLOBAL	scalbn_callee
	GLOBAL	scalbln
	GLOBAL	scalbln_callee
	GLOBAL	log
	GLOBAL	log10
	GLOBAL	log1p
	GLOBAL	log2
	GLOBAL	logb
	GLOBAL	fabs
	GLOBAL	hypot
	GLOBAL	hypot_callee
	GLOBAL	pow
	GLOBAL	pow_callee
	GLOBAL	sqrt
	GLOBAL	cbrt
	GLOBAL	erf
	GLOBAL	erfc
	GLOBAL	lgamma
	GLOBAL	tgamma
	GLOBAL	ceil
	GLOBAL	floor
	GLOBAL	nearbyint
	GLOBAL	rint
	GLOBAL	lrint
	GLOBAL	round
	GLOBAL	lround
	GLOBAL	trunc
	GLOBAL	modf
	GLOBAL	modf_callee
	GLOBAL	fmod
	GLOBAL	fmod_callee
	GLOBAL	remainder
	GLOBAL	remainder_callee
	GLOBAL	remquo
	GLOBAL	remquo_callee
	GLOBAL	copysign
	GLOBAL	copysign_callee
	GLOBAL	nan
	GLOBAL	nextafter
	GLOBAL	nextafter_callee
	GLOBAL	nexttoward
	GLOBAL	nexttoward_callee
	GLOBAL	fdim
	GLOBAL	fdim_callee
	GLOBAL	fmax
	GLOBAL	fmax_callee
	GLOBAL	fmin
	GLOBAL	fmin_callee
	GLOBAL	fma
	GLOBAL	fma_callee
	GLOBAL	isgreater
	GLOBAL	isgreater_callee
	GLOBAL	isgreaterequal
	GLOBAL	isgreaterequal_callee
	GLOBAL	isless
	GLOBAL	isless_callee
	GLOBAL	islessequal
	GLOBAL	islessequal_callee
	GLOBAL	islessgreater
	GLOBAL	islessgreater_callee
	GLOBAL	isunordered
	GLOBAL	isunordered_callee
	GLOBAL	f16_f48
	GLOBAL	f48_f16
	GLOBAL	f16_f32
	GLOBAL	f32_f16
	GLOBAL	i16_f16
	GLOBAL	u16_f16
	GLOBAL	i32_f16
	GLOBAL	u32_f16
	GLOBAL	f16_i8
	GLOBAL	f16_i16
	GLOBAL	f16_i32
	GLOBAL	f16_u8
	GLOBAL	f16_u16
	GLOBAL	f16_u32
	GLOBAL	addf16
	GLOBAL	addf16_callee
	GLOBAL	subf16
	GLOBAL	subf16_callee
	GLOBAL	mulf16
	GLOBAL	mulf16_callee
	GLOBAL	divf16
	GLOBAL	divf16_callee
	GLOBAL	fmaf16
	GLOBAL	fmaf16_callee
	GLOBAL	polyf16
	GLOBAL	polyf16_callee
	GLOBAL	hypotf16
	GLOBAL	hypotf16_callee
	GLOBAL	invf16
	GLOBAL	invsqrtf16
	GLOBAL	sqrtf16
	GLOBAL	div2f16
	GLOBAL	mul2f16
	GLOBAL	mul10f16
	GLOBAL	frexpf16
	GLOBAL	frexpf16_callee
	GLOBAL	ldexpf16
	GLOBAL	ldexpf16_callee
	GLOBAL	acosf16
	GLOBAL	asinf16
	GLOBAL	atanf16
	GLOBAL	cosf16
	GLOBAL	sinf16
	GLOBAL	tanf16
	GLOBAL	expf16
	GLOBAL	exp2f16
	GLOBAL	exp10f16
	GLOBAL	logf16
	GLOBAL	log2f16
	GLOBAL	log10f16
	GLOBAL	powf16
	GLOBAL	powf16_callee
	GLOBAL	fabsf16
	GLOBAL	negf16
	GLOBAL	ceilf16
	GLOBAL	floorf16
	GLOBAL	isgreaterf16
	GLOBAL	isgreaterf16_callee
	GLOBAL	isgreaterequalf16
	GLOBAL	isgreaterequalf16_callee
	GLOBAL	islessf16
	GLOBAL	islessf16_callee
	GLOBAL	islessequalf16
	GLOBAL	islessequalf16_callee
	GLOBAL	islessgreaterf16
	GLOBAL	islessgreaterf16_callee
	GLOBAL	isnotequalf16
	GLOBAL	isnotequalf16_callee
	GLOBAL	isunorderedf16
	GLOBAL	isunorderedf16_callee
	GLOBAL	_f16_coeff_sin
	GLOBAL	_f16_coeff_cos


; --- End of Scope Defns ---


; --- End of Compilation ---
