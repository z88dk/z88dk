;* * * * *  Small-C/Plus z88dk * * * * *
;  Version: 25461-415806f08c-20260813
;
;	Reconstructed for z80 Module Assembler
;
;	Module compile time: Thu Sep  3 23:50:16 2026


	C_LINE	0,"m32_sinf.c"

	MODULE	m32_sinf_c


	INCLUDE "z80_crt0.hdr"


	EXTERN	saved_hl
	C_LINE	0,"m32_math.h"
	C_LINE	0,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	0,"/data/z88dk/lib/config/../..//include/sys/compiler.h"
	C_LINE	0,"/data/z88dk/lib/config/../..//include/sys/proto.h"
	C_LINE	6,"/data/z88dk/lib/config/../..//include/sys/compiler.h"
	C_LINE	10,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	0,"/data/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	17,"/data/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	26,"/data/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	38,"/data/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	44,"/data/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	49,"/data/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	54,"/data/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	59,"/data/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	64,"/data/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	69,"/data/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	74,"/data/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	79,"/data/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	84,"/data/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	89,"/data/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	93,"/data/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	94,"/data/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	95,"/data/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	97,"/data/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	98,"/data/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	99,"/data/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	105,"/data/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	110,"/data/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	11,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	13,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	14,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	15,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	17,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	18,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	19,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	21,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	22,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	23,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	25,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	26,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	27,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	29,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	30,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	31,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	33,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	34,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	35,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	37,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	38,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	40,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	41,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	43,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	44,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	49,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	52,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	54,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	55,"/data/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	34,"m32_math.h"
	C_LINE	0,"/data/z88dk/lib/config/../..//include/math.h"
	C_LINE	0,"/data/z88dk/lib/config/../..//include/limits.h"
	C_LINE	7,"/data/z88dk/lib/config/../..//include/math.h"
	C_LINE	0,"/data/z88dk/lib/config/../..//include/float.h"
	C_LINE	0,"/data/z88dk/lib/config/../..//include/math.h"
	C_LINE	6,"/data/z88dk/lib/config/../..//include/float.h"
	C_LINE	8,"/data/z88dk/lib/config/../..//include/math.h"
	C_LINE	0,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	30,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	31,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	33,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	34,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	36,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	37,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	38,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	39,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	41,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	42,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	43,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	44,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	45,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	46,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	120,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	121,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	122,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	123,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	125,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	126,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	127,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	130,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	131,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	132,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	133,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	137,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	138,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	139,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	140,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	142,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	143,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	144,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	147,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	148,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	149,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	150,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	151,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	152,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	153,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	156,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	157,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	163,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	164,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	168,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	169,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	172,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	173,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	34,"/data/z88dk/lib/config/../..//include/math.h"
	C_LINE	0,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	38,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	39,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	40,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	42,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	43,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	44,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	50,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	51,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	52,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	54,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	55,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	56,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	62,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	64,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	69,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	70,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	71,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	73,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	74,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	75,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	81,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	82,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	83,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	85,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	86,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	87,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	94,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	95,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	96,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	97,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	98,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	101,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	102,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	103,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	104,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	110,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	116,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	117,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	118,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	119,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	120,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	121,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	124,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	125,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	126,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	127,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	128,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	129,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	142,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	143,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	144,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	146,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	147,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	148,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	154,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	156,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	160,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	162,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	172,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	173,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	174,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	176,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	177,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	178,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	185,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	187,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	192,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	194,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	197,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	199,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	204,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	206,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	210,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	212,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	216,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	218,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	222,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	224,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	229,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	230,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	231,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	242,"/data/z88dk/lib/config/../..//include/math/math_math32.h"
	C_LINE	37,"/data/z88dk/lib/config/../..//include/math.h"
	C_LINE	35,"m32_math.h"
	C_LINE	37,"m32_math.h"
	C_LINE	48,"m32_math.h"
	C_LINE	49,"m32_math.h"
	C_LINE	50,"m32_math.h"
	C_LINE	51,"m32_math.h"
	C_LINE	52,"m32_math.h"
	C_LINE	53,"m32_math.h"
	C_LINE	54,"m32_math.h"
	C_LINE	57,"m32_math.h"
	C_LINE	58,"m32_math.h"
	C_LINE	59,"m32_math.h"
	C_LINE	60,"m32_math.h"
	C_LINE	61,"m32_math.h"
	C_LINE	62,"m32_math.h"
	C_LINE	65,"m32_math.h"
	C_LINE	66,"m32_math.h"
	C_LINE	67,"m32_math.h"
	C_LINE	68,"m32_math.h"
	C_LINE	69,"m32_math.h"
	C_LINE	70,"m32_math.h"
	C_LINE	71,"m32_math.h"
	C_LINE	74,"m32_math.h"
	C_LINE	75,"m32_math.h"
	C_LINE	76,"m32_math.h"
	C_LINE	77,"m32_math.h"
	C_LINE	78,"m32_math.h"
	C_LINE	79,"m32_math.h"
	C_LINE	82,"m32_math.h"
	C_LINE	83,"m32_math.h"
	C_LINE	84,"m32_math.h"
	C_LINE	85,"m32_math.h"
	C_LINE	86,"m32_math.h"
	C_LINE	87,"m32_math.h"
	C_LINE	88,"m32_math.h"
	C_LINE	89,"m32_math.h"
	C_LINE	90,"m32_math.h"
	C_LINE	91,"m32_math.h"
	C_LINE	33,"m32_sinf.c"
	C_LINE	35,"m32_sinf.c"
	C_LINE	36,"m32_sinf.c"
	C_LINE	38,"m32_sinf.c"
	SECTION	code_compiler

; Function m32_sinf flags 0x00000208 __smallc __z88dk_fastcall 
; double m32_sinf(double f)
; parameter 'double f' at sp+2 size(4)
	C_LINE	39,"m32_sinf.c::m32_sinf::0::0"
._m32_sinf
	push	de
	push	hl
	ld	hl,65522	;const
	add	hl,sp
	ld	sp,hl
	dec	sp
	pop	hl
	ld	l,1
	push	hl
	ld	hl,11	;const
	add	hl,sp
	push	hl
	ld	hl,17	;const
	add	hl,sp
	call	l_glong
	pop	bc
	call	l_plong
	ld	hl,11	;const
	add	hl,sp
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_lt
	ld	a,h
	or	l
	jp	z,i_2	;
	ld	hl,0	;const
	add	hl,sp
	ld	d,h
	ld	e,l
	ld	a,255
	ld	(de),a
	ld	hl,11	;const
	add	hl,sp
	push	hl
	call	l_glong
	ld	a,d
	xor	128
	ld	d,a
	pop	bc
	call	l_plong
.i_2
	push	bc
	push	bc
	ld	hl,0	;const
	add	hl,sp
	push	hl
	ld	hl,17	;const
	add	hl,sp
	call	l_glong
	pop	bc
	call	l_plong
	ld	hl,2	;const
	add	hl,sp
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	hl,7
	call	l_asr_u
	inc	e
	ld	h,0
	ld	de,0
	push	de
	push	hl
	ld	hl,134	;const
	ld	de,0
	call	l_long_uge
	jp	nc,i_3	;
	ld	hl,15	;const
	add	hl,sp
	push	hl
	call	l_glong2sp
	ld	hl,4059	;const
	ld	de,16585
	push	de
	push	hl
	call	_m32_fmodf
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	call	l_plong
.i_3
	pop	bc
	pop	bc
	ld	hl,1	;const
	add	hl,sp
	push	hl
	ld	hl,13	;const
	add	hl,sp
	call	l_glong2sp
	ld	hl,63875	;const
	ld	de,16290
	call	l_f32_mul
	call	l_f32_f2sint
	pop	de
	ex	de,hl	;l_pint
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
	ld	hl,7	;const
	add	hl,sp
	push	hl
	call	l_gint3sp	;
	call	l_f32_uint2f
	pop	bc
	call	l_plong
	call	l_gint1sp	;
	ld	a,l
	and	1
	jp	z,i_4	;
	ld	hl,1	;const
	add	hl,sp
	push	hl
	ld	a,(hl)	;l_gint
	inc	hl
	ld	h,(hl)
	ld	l,a
	inc	hl
	pop	de
	ex	de,hl	;l_pint
	ld	(hl),e
	inc	hl
	ld	(hl),d
 	ex	de,hl
	ld	hl,7	;const
	add	hl,sp
	push	hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	de,16256
	call	l_f32_add
	pop	bc
	call	l_plong
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
	ld	a,l
	sub	e
	ld	a,h
	sbc	d
	jp	nc,i_5	;
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
.i_5
	ld	hl,11	;const
	add	hl,sp
	push	hl
	call	l_glong2sp
	ld	hl,13	;const
	add	hl,sp
	call	l_glong2sp
	ld	hl,4059	;const
	ld	de,16201
	call	l_f32_mul
	call	l_f32_sub
	pop	bc
	call	l_plong
	ld	hl,3	;const
	add	hl,sp
	push	hl
	ld	hl,13	;const
	add	hl,sp
	call	l_glong
	call	_m32_sqrf
	pop	bc
	call	l_plong
	call	l_gint1sp	;
	ld	de,1
	call	l_eq
	jp	c,i_7	;
	call	l_gint1sp	;
	ld	de,2
	call	l_eq
	jp	nc,i_6	;
.i_7
	ld	hl,7	;const
	add	hl,sp
	push	hl
	ld	hl,5	;const
	add	hl,sp
	call	l_glong2sp
	ld	hl,_m32_coeff_cos
	push	hl
	ld	hl,4	;const
	push	hl
	call	_m32_polyf
	push	de
	push	hl
	ld	hl,9	;const
	add	hl,sp
	call	l_glong
	ld	a,-1
	call	l_f32_ldexp
	call	l_f32_sub
	push	de
	push	hl
	ld	hl,0	;const
	ld	de,16256
	call	l_f32_add
	pop	bc
	call	l_plong
	jp	i_9	;EOS
.i_6
	ld	hl,7	;const
	add	hl,sp
	push	hl
	ld	hl,5	;const
	add	hl,sp
	call	l_glong2sp
	ld	hl,_m32_coeff_sin
	push	hl
	ld	hl,3	;const
	push	hl
	call	_m32_polyf
	push	de
	push	hl
	ld	hl,17	;const
	add	hl,sp
	call	l_glong
	call	l_f32_mul
	push	de
	push	hl
	ld	hl,17	;const
	add	hl,sp
	call	l_glong
	call	l_f32_add
	pop	bc
	call	l_plong
.i_9
	ld	hl,0	;const
	add	hl,sp
	ld	a,(hl)
	rla
	jp	nc,i_10	;
	ld	hl,7	;const
	add	hl,sp
	call	l_glong
	ld	a,d
	xor	128
	ld	d,a
	jp	i_11	;
.i_10
	ld	hl,7	;const
	add	hl,sp
	call	l_glong
.i_11
	ld	b,h
	ld	c,l
	ld	hl,19	;const
	add	hl,sp
	ld	sp,hl
	ld	h,b
	ld	l,c
	ret


	SECTION	bss_compiler
	SECTION	code_compiler
; --- Start of Optimiser additions ---


; --- Start of Static Variables ---

	SECTION	bss_compiler
	SECTION	code_compiler


; --- Start of Scope Defns ---

	GLOBAL	f16_f48
	GLOBAL	f16_f32
	GLOBAL	f48_f16
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
	GLOBAL	subf16
	GLOBAL	mulf16
	GLOBAL	divf16
	GLOBAL	fmaf16
	GLOBAL	polyf16
	GLOBAL	hypotf16
	GLOBAL	sqrtf16
	GLOBAL	div2f16
	GLOBAL	mul2f16
	GLOBAL	mul10f16
	GLOBAL	acosf16
	GLOBAL	asinf16
	GLOBAL	atanf16
	GLOBAL	atan2f16
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
	GLOBAL	ceilf16
	GLOBAL	floorf16
	GLOBAL	frexpf16
	GLOBAL	ldexpf16
	GLOBAL	invf16
	GLOBAL	invsqrtf16
	GLOBAL	fabsf16
	GLOBAL	negf16
	GLOBAL	sin
	GLOBAL	cos
	GLOBAL	tan
	GLOBAL	sin_fastcall
	GLOBAL	cos_fastcall
	GLOBAL	tan_fastcall
	GLOBAL	asin
	GLOBAL	acos
	GLOBAL	atan
	GLOBAL	asin_fastcall
	GLOBAL	acos_fastcall
	GLOBAL	atan_fastcall
	GLOBAL	atan2
	GLOBAL	atan2_callee
	GLOBAL	sinh
	GLOBAL	cosh
	GLOBAL	tanh
	GLOBAL	sinh_fastcall
	GLOBAL	cosh_fastcall
	GLOBAL	tanh_fastcall
	GLOBAL	asinh
	GLOBAL	acosh
	GLOBAL	atanh
	GLOBAL	asinh_fastcall
	GLOBAL	acosh_fastcall
	GLOBAL	atanh_fastcall
	GLOBAL	inv
	GLOBAL	invsqrt
	GLOBAL	sqr
	GLOBAL	sqrt
	GLOBAL	pow
	GLOBAL	inv_fastcall
	GLOBAL	invsqrt_fastcall
	GLOBAL	sqr_fastcall
	GLOBAL	sqrt_fastcall
	GLOBAL	pow_callee
	GLOBAL	exp
	GLOBAL	exp2
	GLOBAL	exp10
	GLOBAL	log
	GLOBAL	log2
	GLOBAL	log10
	GLOBAL	exp_fastcall
	GLOBAL	exp2_fastcall
	GLOBAL	exp10_fastcall
	GLOBAL	log_fastcall
	GLOBAL	log2_fastcall
	GLOBAL	log10_fastcall
	GLOBAL	ceil
	GLOBAL	floor
	GLOBAL	round
	GLOBAL	ceil_fastcall
	GLOBAL	floor_fastcall
	GLOBAL	round_fastcall
	GLOBAL	fmin
	GLOBAL	fmin_callee
	GLOBAL	fmax
	GLOBAL	fmax_callee
	GLOBAL	div2
	GLOBAL	mul2
	GLOBAL	mul10u
	GLOBAL	div2_fastcall
	GLOBAL	mul2_fastcall
	GLOBAL	mul10u_fastcall
	GLOBAL	ldexp
	GLOBAL	ldexp_callee
	GLOBAL	modf
	GLOBAL	modf_callee
	GLOBAL	frexp
	GLOBAL	frexp_callee
	GLOBAL	fabs
	GLOBAL	fabs_fastcall
	GLOBAL	fmod
	GLOBAL	fmod_callee
	GLOBAL	hypot
	GLOBAL	hypot_callee
	GLOBAL	poly
	GLOBAL	poly_callee
	GLOBAL	atof
	GLOBAL	ftoa
	GLOBAL	ftoe
	GLOBAL	fpclassify
	GLOBAL	_m32_sinf
	GLOBAL	_m32_cosf
	GLOBAL	_m32_tanf
	GLOBAL	_m32_asinf
	GLOBAL	_m32_acosf
	GLOBAL	_m32_atanf
	GLOBAL	_m32_atan2f
	GLOBAL	_m32_sinhf
	GLOBAL	_m32_coshf
	GLOBAL	_m32_tanhf
	GLOBAL	_m32_asinhf
	GLOBAL	_m32_acoshf
	GLOBAL	_m32_atanhf
	GLOBAL	_m32_expf
	GLOBAL	_m32_exp2f
	GLOBAL	_m32_exp10f
	GLOBAL	_m32_logf
	GLOBAL	_m32_log2f
	GLOBAL	_m32_log10f
	GLOBAL	_m32_powf
	GLOBAL	_m32_ceilf
	GLOBAL	_m32_fabsf
	GLOBAL	_m32_floorf
	GLOBAL	_m32_roundf
	GLOBAL	_m32_fmodf
	GLOBAL	_m32_modff
	GLOBAL	_m32_mul2f
	GLOBAL	_m32_div2f
	GLOBAL	_m32_sqrf
	GLOBAL	_m32_invf
	GLOBAL	_m32_sqrtf
	GLOBAL	_m32_invsqrtf
	GLOBAL	_m32_frexpf
	GLOBAL	_m32_ldexpf
	GLOBAL	_m32_hypotf
	GLOBAL	_m32_polyf
	GLOBAL	_m32_coeff_sin
	GLOBAL	_m32_coeff_cos


; --- End of Scope Defns ---


; --- End of Compilation ---
