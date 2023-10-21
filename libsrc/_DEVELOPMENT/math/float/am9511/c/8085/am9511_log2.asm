;* * * * *  Small-C/Plus z88dk * * * * *
;  Version: 21234-4d9c2f0cbb-20230615
;
;	Reconstructed for z80 Module Assembler
;
;	Module compile time: Thu Jun 15 13:54:56 2023


	C_LINE	0,"am9511_log2.c"

	MODULE	am9511_log2_c


	INCLUDE "z80_crt0.hdr"


	EXTERN	saved_hl
	EXTERN	saved_de
	C_LINE	0,"am9511_math.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/compiler.h"
	C_LINE	10,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	17,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	26,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	35,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	40,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	45,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	50,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	55,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	60,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	65,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	70,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	75,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	80,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	85,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	89,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	90,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	91,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	93,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	94,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	95,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	101,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	106,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	11,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	13,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	14,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	15,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	17,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	18,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	19,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	21,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	22,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	23,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	25,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	26,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	27,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	29,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	30,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	31,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	33,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	34,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	35,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	37,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	38,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	40,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	41,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	43,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	44,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	49,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	52,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	54,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	55,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	34,"am9511_math.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/math.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/limits.h"
	C_LINE	7,"/home/phillip/Z80/z88dk/lib/config/../..//include/math.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/float.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/math.h"
	C_LINE	6,"/home/phillip/Z80/z88dk/lib/config/../..//include/float.h"
	C_LINE	8,"/home/phillip/Z80/z88dk/lib/config/../..//include/math.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	28,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	29,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	31,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	32,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	34,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	35,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	36,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	37,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	39,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	40,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	41,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	42,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	43,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	44,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	120,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	121,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	122,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	123,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	125,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	126,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	127,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	130,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	131,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	132,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	133,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	136,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	137,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	138,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	139,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	141,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	142,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	143,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	146,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	147,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	148,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	149,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	150,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	151,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	152,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	155,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	156,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	162,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	163,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	167,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	168,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	171,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	172,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	34,"/home/phillip/Z80/z88dk/lib/config/../..//include/math.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	37,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	38,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	39,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	40,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	41,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	42,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	43,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	46,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	47,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	48,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	49,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	50,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	51,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	54,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	55,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	56,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	57,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	61,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	62,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	63,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	64,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	65,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	66,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	71,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	72,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	73,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	74,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	75,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	81,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	82,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	83,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	84,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	85,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	89,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	90,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	91,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	95,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	96,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	97,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	98,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	102,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	103,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	104,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	106,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	107,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	194,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_am9511.h"
	C_LINE	39,"/home/phillip/Z80/z88dk/lib/config/../..//include/math.h"
	C_LINE	35,"am9511_math.h"
	C_LINE	37,"am9511_math.h"
	C_LINE	97,"am9511_math.h"
	C_LINE	98,"am9511_math.h"
	C_LINE	99,"am9511_math.h"
	C_LINE	100,"am9511_math.h"
	C_LINE	101,"am9511_math.h"
	C_LINE	102,"am9511_math.h"
	C_LINE	104,"am9511_math.h"
	C_LINE	107,"am9511_math.h"
	C_LINE	108,"am9511_math.h"
	C_LINE	109,"am9511_math.h"
	C_LINE	110,"am9511_math.h"
	C_LINE	111,"am9511_math.h"
	C_LINE	112,"am9511_math.h"
	C_LINE	115,"am9511_math.h"
	C_LINE	116,"am9511_math.h"
	C_LINE	117,"am9511_math.h"
	C_LINE	119,"am9511_math.h"
	C_LINE	120,"am9511_math.h"
	C_LINE	121,"am9511_math.h"
	C_LINE	124,"am9511_math.h"
	C_LINE	125,"am9511_math.h"
	C_LINE	126,"am9511_math.h"
	C_LINE	127,"am9511_math.h"
	C_LINE	128,"am9511_math.h"
	C_LINE	129,"am9511_math.h"
	C_LINE	132,"am9511_math.h"
	C_LINE	133,"am9511_math.h"
	C_LINE	134,"am9511_math.h"
	C_LINE	135,"am9511_math.h"
	C_LINE	17,"am9511_log2.c"
	C_LINE	19,"am9511_log2.c"
	SECTION	code_compiler

; Function am9511_log2 flags 0x00000208 __smallc __z88dk_fastcall 
; double am9511_log2(double x)
; parameter 'double x' at sp+2 size(4)
	C_LINE	20,"am9511_log2.c::am9511_log2::0::0"
._am9511_log2
	push	de
	push	hl
	push	bc
	push	bc
	ld	de,sp+4
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_le
	ld	a,h
	or	l
	jp	z,i_2	;
	push	bc
	push	bc
	ld	hl,0	;const
	add	hl,sp
	ld	(hl),255
	inc	hl
	ld	(hl),255
	inc	hl
	ld	(hl),255
	inc	hl
	ld	(hl),255
	ld	de,sp+0
	ex	de,hl
	call	l_glong
	ld	b,h
	ld	c,l
	ld	hl,12	;const
	add	hl,sp
	ld	sp,hl
	ld	h,b
	ld	l,c
	ret


.i_2
	ld	de,sp+4
	ex	de,hl
	call	l_glong
	call	_log
	push	de
	push	hl
	ld	hl,43579	;const
	ld	de,16312
	call	l_f32_mul
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	ret


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
	GLOBAL	_sin
	GLOBAL	_cos
	GLOBAL	_tan
	GLOBAL	_asin
	GLOBAL	_acos
	GLOBAL	_atan
	GLOBAL	atan2
	GLOBAL	sinh
	GLOBAL	cosh
	GLOBAL	tanh
	GLOBAL	asinh
	GLOBAL	acosh
	GLOBAL	atanh
	GLOBAL	_sqr
	GLOBAL	_sqrt
	GLOBAL	pow
	GLOBAL	pow_callee
	GLOBAL	_exp
	GLOBAL	exp2
	GLOBAL	exp10
	GLOBAL	_log
	GLOBAL	log2
	GLOBAL	_log10
	GLOBAL	_ceil
	GLOBAL	_floor
	GLOBAL	round
	GLOBAL	_fmax
	GLOBAL	_fmin
	GLOBAL	_div2
	GLOBAL	_mul2
	GLOBAL	mul10u
	GLOBAL	ldexp
	GLOBAL	ldexp_callee
	GLOBAL	modf
	GLOBAL	frexp
	GLOBAL	frexp_callee
	GLOBAL	_fabs
	GLOBAL	_fmod
	GLOBAL	hypot
	GLOBAL	hypot_callee
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


; --- End of Scope Defns ---


; --- End of Compilation ---
