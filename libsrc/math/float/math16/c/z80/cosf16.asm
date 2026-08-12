;* * * * *  Small-C/Plus z88dk * * * * *
;  Version: 23073-08765eb48b-20250127
;
;	Reconstructed for z80 Module Assembler
;
;	Module compile time: Thu Jan 30 00:49:22 2025


	C_LINE	0,"cosf16.c"

	MODULE	cosf16_c


	INCLUDE "z80_crt0.hdr"


	C_LINE	0,"math16.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	7,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	8,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	9,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	11,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	12,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	13,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	15,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	16,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	17,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	19,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	20,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	21,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	23,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	24,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	25,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	27,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	28,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	29,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	35,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	36,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	38,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	39,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	41,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	42,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	46,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	49,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	55,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	56,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/stdint.h"
	C_LINE	34,"math16.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	17,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	28,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	37,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	62,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	65,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	68,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	72,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	73,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	78,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	81,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	84,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	88,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	91,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	94,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	98,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	101,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	104,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	108,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	111,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	114,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	117,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	118,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	122,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	123,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	127,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	128,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	132,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	133,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	138,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	142,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	145,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	148,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	151,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	154,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	158,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	161,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	162,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	166,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	167,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	172,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	175,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	179,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	182,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	185,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	188,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	192,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	195,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	198,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	201,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	204,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	207,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	210,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	213,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	218,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	219,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	223,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	224,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	229,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	230,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	234,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	235,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	240,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	241,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	245,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	249,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	250,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	254,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	255,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	260,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	261,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	265,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	266,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	270,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	271,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	276,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	277,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	282,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	283,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	287,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	288,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	292,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	293,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	297,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	298,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	302,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	303,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	307,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	308,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	316,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	319,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	323,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	326,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	330,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	333,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	336,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	339,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	343,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	346,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	349,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	352,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	355,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	358,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	362,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	363,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	367,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	368,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	372,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	373,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	377,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	378,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	383,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	384,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	388,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	389,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	393,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	394,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	399,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	402,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	406,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	410,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	413,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	416,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	419,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	420,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	424,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	425,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	430,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	433,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	436,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	439,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	440,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	445,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	448,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	451,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	455,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	458,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	461,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	464,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	467,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	470,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	473,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	474,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	479,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	482,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	485,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	488,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	492,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	493,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	497,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	498,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	502,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	503,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	507,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	508,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	512,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	513,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	517,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	518,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	522,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
	C_LINE	523,"/home/phillip/Z80/z88dk/lib/config/../..//include/sccz80/math.h"
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
	GLOBAL	___cosf16
.___cosf16
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
	call	l_gint3sp	;
	call	l_f16_uint2f
	pop	de
	ex	de,hl	;l_pint
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
	call	l_gint1sp	;
	ld	a,l
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
	call	l_gint1sp	;
	ld	de,3
	ex	de,hl
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
	call	l_gint1sp	;
	ld	de,1
	ex	de,hl
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
	call	l_gint1sp	;
	ld	de,1
	and	a
	sbc	hl,de
	jp	z,i_10	;
	call	l_gint1sp	;
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
	call	l_gint7sp	;
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
	call	l_gint5sp	;
	ld	a,h
	xor	128
	ld	h,a
	jp	i_15	;
.i_14
	call	l_gint5sp	;
.i_15
	exx
	ld	hl,11	;const
	add	hl,sp
	ld	sp,hl
	exx
	ret


	SECTION	bss_compiler
	SECTION	code_compiler
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
	GLOBAL	ldexp
	GLOBAL	ldexp_callee
	GLOBAL	scalbn
	GLOBAL	scalbn_callee
	GLOBAL	scalbln
	GLOBAL	scalbln_callee
	GLOBAL	ilogb
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
