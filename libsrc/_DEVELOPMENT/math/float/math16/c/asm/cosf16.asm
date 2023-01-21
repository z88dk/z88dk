;* * * * *  Small-C/Plus z88dk * * * * *
;  Version: 19569-078eaec31-20220528
;
;	Reconstructed for z80 Module Assembler
;
;	Module compile time: Sun Jan 22 01:10:14 2023


	C_LINE	0,"cosf16.c"

	MODULE	cosf16_c


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
	C_LINE	61,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	63,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	64,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	66,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	67,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	73,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	76,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	94,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	95,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/stdint.h"
	C_LINE	34,"math16.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	24,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	41,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	53,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	180,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	183,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	186,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	189,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	190,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	195,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	198,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	201,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	205,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	208,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	211,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	215,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	218,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	221,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	225,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	228,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	231,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	234,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	235,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	239,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	242,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	243,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	247,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	248,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	252,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	253,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	258,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	261,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	264,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	267,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	270,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	274,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	277,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	278,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	283,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	284,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	288,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	291,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	295,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	298,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	301,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	304,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	308,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	311,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	314,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	317,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	320,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	323,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	326,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	329,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	333,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	334,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	338,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	339,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	343,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	344,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	348,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	349,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	354,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	355,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	359,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	363,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	364,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	368,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	369,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	374,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	375,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	380,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	381,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	385,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	386,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	391,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	392,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	397,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	398,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	402,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	403,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	407,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	408,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	412,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	413,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	417,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	418,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	422,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	423,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	493,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	496,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	500,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	503,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	507,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	510,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	513,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	516,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	520,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	523,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	526,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	529,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	532,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	535,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	539,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	540,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	544,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	545,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	549,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	550,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	554,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	555,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	560,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	561,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	565,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	566,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	570,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	571,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	576,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	579,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	583,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	587,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	590,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	593,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	596,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	597,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	601,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	602,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	607,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	610,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	613,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	616,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	617,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	622,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	625,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	628,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	632,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	635,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	638,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	641,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	644,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	647,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	650,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	651,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	656,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	659,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	662,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	665,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	669,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	670,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	674,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	675,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	679,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	680,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	684,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	685,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	689,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	690,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	694,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	695,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	699,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	700,"/home/phillip/Z80/z88dk/lib/config/../..//include/_DEVELOPMENT/sccz80/math.h"
	C_LINE	35,"math16.h"
	C_LINE	33,"cosf16.c"
	C_LINE	35,"cosf16.c"
	C_LINE	36,"cosf16.c"
	C_LINE	38,"cosf16.c"
	SECTION	code_compiler

; Function cosf16 flags 0x00000288 __smallc __z88dk_fastcall 
; _Float16 half_tcosf16(_Float16 xx)
; parameter '_Float16 xx' at sp+2 size(2)
	C_LINE	39,"cosf16.c::cosf16::0::0"
.cosf16
	GLOBAL	_cosf16
._cosf16
	push	hl
	push	bc
	push	bc
	push	bc
	push	bc
	dec	sp
	pop	hl
	ld	l,1
	push	hl
	ld	hl,7	;const
	add	hl,sp
	ex	de,hl
	ld	hl,9	;const
	add	hl,sp
	ldi
	ldi
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
	jp	z,i_2	;
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
	pop	de
	ex	de,hl	;l_pint
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
	ld	hl,15639	;const
	call	l_f16_mul
	call	l_f16_f2sint
	pop	de
	ex	de,hl	;l_pint
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
	ld	hl,5	;const
	add	hl,sp
	push	hl
	ld	hl,3	;const
	add	hl,sp
	ld	a,(hl)	;l_gint
	inc	hl
	ld	h,(hl)
	ld	l,a
	call	l_f16_uint2f
	pop	de
	ex	de,hl	;l_pint
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
	ld	hl,1	;const
	add	hl,sp
	ld	a,(hl)	;l_gint
	inc	hl
	ld	h,(hl)
	ld	l,a
	and	1
	jp	z,i_4	;
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
	pop	de
	ex	de,hl	;l_pint
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
.i_4
	ld	hl,1	;const
	add	hl,sp
	push	hl
	ld	a,(hl)
	and	7
	ld	l,a
	ld	h,0
	pop	de
	ex	de,hl	;l_pint
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
	jp	nc,i_6	;
	ld	hl,0	;const
	add	hl,sp
	push	hl
	ld	a,(hl)	;l_gchar
	ld	l,a
	rla
	sbc	a
	ld	h,a
	ld	a,l		;l_neg
	cpl
	ld	l,a
	ld	a,h
	cpl
	ld	h,a
	inc	hl
	ld	a,l
	pop	de
	ld	(de),a
	ld	hl,1	;const
	add	hl,sp
	push	hl
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	ld	hl,-4
	add	hl,bc
	pop	de
	ex	de,hl	;l_pint
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
.i_6
	ld	hl,1	;const
	add	hl,sp
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	hl,1
	and	a
	sbc	hl,de
	jp	nc,i_7	;
	ld	hl,0	;const
	add	hl,sp
	push	hl
	ld	a,(hl)
	neg
	pop	de
	ld	(de),a
.i_7
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
	pop	de
	ex	de,hl	;l_pint
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
	ld	hl,3	;const
	add	hl,sp
	push	hl
	ld	hl,9	;const
	add	hl,sp
	ld	a,(hl)	;l_gint
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	hl
	call	l_f16_mul
	pop	de
	ex	de,hl	;l_pint
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
	ld	hl,1	;const
	add	hl,sp
	ld	a,(hl)	;l_gint
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	de,1
	and	a
	sbc	hl,de
	jp	z,i_10	;
	ld	hl,1	;const
	add	hl,sp
	ld	a,(hl)	;l_gint
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	de,2
	and	a
	sbc	hl,de
	jp	nz,i_9	;
.i_10
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
	add	hl,sp
	ld	a,(hl)	;l_gint
	inc	hl
	ld	h,(hl)
	ld	l,a
	call	l_f16_mul
	push	hl
	ld	hl,11	;const
	add	hl,sp
	ld	a,(hl)	;l_gint
	inc	hl
	ld	h,(hl)
	ld	l,a
	call	l_f16_add
	pop	de
	ex	de,hl	;l_pint
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
	jp	i_12	;EOS
.i_9
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
	add	hl,sp
	ld	a,(hl)	;l_gint
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	a,-1
	call	l_f16_ldexp
	call	l_f16_sub
	push	hl
	ld	hl,15360	;const
	call	l_f16_add
	pop	de
	ex	de,hl	;l_pint
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
.i_12
	ld	hl,0	;const
	add	hl,sp
	ld	a,(hl)
	rla
	jp	nc,i_14	;
	ld	hl,5	;const
	add	hl,sp
	ld	a,(hl)	;l_gint
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	a,h
	xor	128
	ld	h,a
	jp	i_15	;
.i_14
	ld	hl,5	;const
	add	hl,sp
	ld	a,(hl)	;l_gint
	inc	hl
	ld	h,(hl)
	ld	l,a
.i_15
	exx
	ld	hl,11	;const
	add	hl,sp
	ld	sp,hl
	exx
	ret


; --- Start of Optimiser additions ---


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
	GLOBAL	atan2f16
	GLOBAL	atan2f16_callee
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
