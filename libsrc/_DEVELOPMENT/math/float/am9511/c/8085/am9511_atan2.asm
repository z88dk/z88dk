;* * * * *  Small-C/Plus z88dk * * * * *
;  Version: 20800-12d49ef78-20230414
;
;	Reconstructed for z80 Module Assembler
;
;	Module compile time: Sun May 14 00:24:05 2023


	C_LINE	0,"am9511_atan2.c"

	MODULE	am9511_atan2_c


	INCLUDE "z80_crt0.hdr"


	EXTERN	saved_hl
	EXTERN	saved_de
	C_LINE	0,"am9511_math.h"
	C_LINE	0,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	0,"/Users/dom/z88dk/lib/config/../..//include/sys/compiler.h"
	C_LINE	10,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	0,"/Users/dom/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	17,"/Users/dom/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	26,"/Users/dom/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	35,"/Users/dom/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	40,"/Users/dom/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	45,"/Users/dom/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	50,"/Users/dom/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	55,"/Users/dom/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	60,"/Users/dom/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	65,"/Users/dom/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	70,"/Users/dom/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	75,"/Users/dom/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	80,"/Users/dom/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	85,"/Users/dom/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	89,"/Users/dom/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	90,"/Users/dom/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	91,"/Users/dom/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	93,"/Users/dom/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	94,"/Users/dom/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	95,"/Users/dom/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	101,"/Users/dom/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	106,"/Users/dom/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	11,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	13,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	14,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	15,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	17,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	18,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	19,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	21,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	22,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	23,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	25,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	26,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	27,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	29,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	30,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	31,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	33,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	34,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	35,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	37,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	38,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	40,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	41,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	43,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	44,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	49,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	52,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	54,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	55,"/Users/dom/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	34,"am9511_math.h"
	C_LINE	0,"/Users/dom/z88dk/lib/config/../..//include/math.h"
	C_LINE	0,"/Users/dom/z88dk/lib/config/../..//include/limits.h"
	C_LINE	7,"/Users/dom/z88dk/lib/config/../..//include/math.h"
	C_LINE	0,"/Users/dom/z88dk/lib/config/../..//include/float.h"
	C_LINE	0,"/Users/dom/z88dk/lib/config/../..//include/math.h"
	C_LINE	6,"/Users/dom/z88dk/lib/config/../..//include/float.h"
	C_LINE	8,"/Users/dom/z88dk/lib/config/../..//include/math.h"
	C_LINE	0,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	28,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	29,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	31,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	32,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	34,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	35,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	36,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	37,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	39,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	40,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	41,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	42,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	43,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	44,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	120,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	121,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	122,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	123,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	125,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	126,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	127,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	130,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	131,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	132,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	133,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	136,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	137,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	138,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	139,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	141,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	142,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	143,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	146,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	147,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	148,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	149,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	150,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	151,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	152,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	155,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	156,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	162,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	163,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	167,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	168,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	171,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	172,"/Users/dom/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	34,"/Users/dom/z88dk/lib/config/../..//include/math.h"
	C_LINE	0,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	37,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	38,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	39,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	40,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	41,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	42,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	43,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	44,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	48,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	49,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	50,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	51,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	52,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	53,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	56,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	57,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	58,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	59,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	64,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	65,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	66,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	67,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	68,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	69,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	74,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	75,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	76,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	82,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	83,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	84,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	85,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	86,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	89,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	90,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	92,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	93,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	97,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	98,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	99,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	102,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	103,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	107,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	108,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	109,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	111,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	112,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	205,"/Users/dom/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	39,"/Users/dom/z88dk/lib/config/../..//include/math.h"
	C_LINE	35,"am9511_math.h"
	C_LINE	37,"am9511_math.h"
	C_LINE	102,"am9511_math.h"
	C_LINE	103,"am9511_math.h"
	C_LINE	104,"am9511_math.h"
	C_LINE	105,"am9511_math.h"
	C_LINE	106,"am9511_math.h"
	C_LINE	107,"am9511_math.h"
	C_LINE	109,"am9511_math.h"
	C_LINE	112,"am9511_math.h"
	C_LINE	113,"am9511_math.h"
	C_LINE	114,"am9511_math.h"
	C_LINE	115,"am9511_math.h"
	C_LINE	116,"am9511_math.h"
	C_LINE	117,"am9511_math.h"
	C_LINE	120,"am9511_math.h"
	C_LINE	121,"am9511_math.h"
	C_LINE	122,"am9511_math.h"
	C_LINE	123,"am9511_math.h"
	C_LINE	125,"am9511_math.h"
	C_LINE	126,"am9511_math.h"
	C_LINE	127,"am9511_math.h"
	C_LINE	130,"am9511_math.h"
	C_LINE	131,"am9511_math.h"
	C_LINE	132,"am9511_math.h"
	C_LINE	134,"am9511_math.h"
	C_LINE	135,"am9511_math.h"
	C_LINE	136,"am9511_math.h"
	C_LINE	139,"am9511_math.h"
	C_LINE	140,"am9511_math.h"
	C_LINE	141,"am9511_math.h"
	C_LINE	142,"am9511_math.h"
	C_LINE	143,"am9511_math.h"
	C_LINE	144,"am9511_math.h"
	C_LINE	145,"am9511_math.h"
	C_LINE	2,"am9511_atan2.c"
	C_LINE	4,"am9511_atan2.c"
	SECTION	code_compiler

; Function am9511_atan2 flags 0x00000000 __stdc 
; double am9511_atan2(double y, double x)
; parameter 'double y' at 2 size(4)
; parameter 'double x' at 6 size(4)
	C_LINE	5,"am9511_atan2.c::am9511_atan2::0::1"
._am9511_atan2
	push	bc
	push	bc
	ld	de,sp+10
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_ne
	ld	a,h
	or	l
	jp	z,i_2	;
	ld	de,sp+10
	ex	de,hl
	call	l_glong
	call	_fabs
	push	de
	push	hl
	ld	de,sp+10
	ex	de,hl
	call	l_glong
	call	_fabs
	call	l_f32_ge
	ld	a,h
	or	l
	jp	z,i_3	;
	ld	hl,0	;const
	add	hl,sp
	push	hl
	ld	de,sp+8
	ex	de,hl
	call	l_glong2sp
	ld	de,sp+16
	ex	de,hl
	call	l_glong
	call	l_f32_div
	call	_atan
	pop	bc
	call	l_plong
	ld	de,sp+10
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_lt
	ld	a,h
	or	l
	jp	z,i_4	;
	ld	de,sp+6
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_ge
	ld	a,h
	or	l
	jp	z,i_5	;
	ld	de,sp+0
	ex	de,hl
	push	hl
	call	l_glong2sp
	ld	hl,4059	;const
	ld	de,16457
	call	l_f32_add
	pop	bc
	call	l_plong
	jp	i_6	;EOS
.i_5
	ld	de,sp+0
	ex	de,hl
	push	hl
	call	l_glong2sp
	ld	hl,4059	;const
	ld	de,16457
	call	l_f32_sub
	pop	bc
	call	l_plong
	jp	i_7	;EOS
.i_3
	ld	hl,0	;const
	add	hl,sp
	push	hl
	ld	de,sp+12
	ex	de,hl
	call	l_glong2sp
	ld	de,sp+12
	ex	de,hl
	call	l_glong
	call	l_f32_div
	call	_atan
	ld	a,d
	xor	128
	ld	d,a
	pop	bc
	call	l_plong
	ld	de,sp+6
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_lt
	ld	a,h
	or	l
	jp	z,i_8	;
	ld	de,sp+0
	ex	de,hl
	push	hl
	call	l_glong2sp
	ld	hl,4058	;const
	ld	de,16329
	call	l_f32_sub
	pop	bc
	call	l_plong
	jp	i_9	;EOS
.i_8
	ld	de,sp+0
	ex	de,hl
	push	hl
	call	l_glong2sp
	ld	hl,4058	;const
	ld	de,16329
	call	l_f32_add
	pop	bc
	call	l_plong
.i_7
	ld	de,sp+0
	ex	de,hl
	call	l_glong
	pop	bc
	pop	bc
	ret


.i_2
	ld	de,sp+6
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_gt
	ld	a,h
	or	l
	jp	z,i_11	;
	ld	hl,4058	;const
	ld	de,16329
	pop	bc
	pop	bc
	ret


.i_11
	ld	de,sp+6
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_lt
	ld	a,h
	or	l
	jp	z,i_13	;
	ld	hl,4058	;const
	ld	de,49097
	pop	bc
	pop	bc
	ret


.i_10
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	pop	bc
	pop	bc
	ret


; --- Start of Optimiser additions ---
	defc	i_6 = i_4
	defc	i_9 = i_7
	defc	i_13 = i_12
	defc	i_12 = i_10
	defc	i_4 = i_7


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
	GLOBAL	_sin
	GLOBAL	_cos
	GLOBAL	_tan
	GLOBAL	_asin
	GLOBAL	_acos
	GLOBAL	_atan
	GLOBAL	atan2
	GLOBAL	atan2_callee
	GLOBAL	sinh
	GLOBAL	cosh
	GLOBAL	tanh
	GLOBAL	asinh
	GLOBAL	acosh
	GLOBAL	atanh
	GLOBAL	_sqr
	GLOBAL	_sqrt
	GLOBAL	pow
	GLOBAL	_pow_callee
	GLOBAL	_exp
	GLOBAL	exp2
	GLOBAL	exp10
	GLOBAL	_log
	GLOBAL	log2
	GLOBAL	_log10
	GLOBAL	_ceil
	GLOBAL	_floor
	GLOBAL	round
	GLOBAL	_div2
	GLOBAL	_mul2
	GLOBAL	mul10u
	GLOBAL	ldexp
	GLOBAL	_ldexp_callee
	GLOBAL	modf
	GLOBAL	modf_callee
	GLOBAL	frexp
	GLOBAL	_frexp_callee
	GLOBAL	_fabs
	GLOBAL	fmod
	GLOBAL	fmod_callee
	GLOBAL	hypot
	GLOBAL	_hypot_callee
	GLOBAL	atof
	GLOBAL	ftoa
	GLOBAL	ftoe
	GLOBAL	f32_fam9511
	GLOBAL	fam9511_f32
	GLOBAL	_fpclassify
	GLOBAL	_am9511_atan2
	GLOBAL	_am9511_sinh
	GLOBAL	_am9511_cosh
	GLOBAL	_am9511_tanh
	GLOBAL	_am9511_asinh
	GLOBAL	_am9511_acosh
	GLOBAL	_am9511_atanh
	GLOBAL	_am9511_log2
	GLOBAL	_am9511_exp2
	GLOBAL	_am9511_exp10
	GLOBAL	_am9511_round
	GLOBAL	_am9511_fmod
	GLOBAL	_am9511_modf


; --- End of Scope Defns ---


; --- End of Compilation ---
