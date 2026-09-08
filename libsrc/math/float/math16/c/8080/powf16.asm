;* * * * *  Small-C/Plus z88dk * * * * *
;  Version: 25461-415806f08c-20260813
;
;	Reconstructed for z80 Module Assembler
;
;	Module compile time: Tue Sep  8 21:16:03 2026



	C_LINE	0,"powf16.c"

	MODULE	powf16_c


	INCLUDE "z80_crt0.hdr"


	EXTERN	saved_hl
	C_LINE	0,"math16.h"
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
	C_LINE	34,"math16.h"
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
	C_LINE	134,"/data/z88dk/lib/config/../..//include/math/math_math16.h"
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
	C_LINE	0,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	39,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	41,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	42,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	43,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	44,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	45,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	46,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	49,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	50,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	51,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	52,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	53,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	54,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	57,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	58,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	64,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	65,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	66,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	73,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	74,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	80,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	81,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	83,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	89,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	90,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	91,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	92,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	99,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	100,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	103,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	104,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	105,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	108,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	109,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	123,"/data/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	49,"/data/z88dk/lib/config/../..//include/math.h"
	C_LINE	35,"math16.h"
	C_LINE	37,"math16.h"
	C_LINE	32,"powf16.c"
	C_LINE	34,"powf16.c"
	C_LINE	36,"powf16.c"
	SECTION	code_compiler

; Function asm_f16_pow flags 0x000002c0 __smallc __z88dk_callee 
; _Float16 half_tasm_f16_pow(_Float16 x, _Float16 y)
; parameter '_Float16 y' at sp+2 size(2)
; parameter '_Float16 x' at sp+4 size(2)
	C_LINE	37,"powf16.c::asm_f16_pow::0::0"
.asm_f16_pow
	GLOBAL	_asm_f16_pow
._asm_f16_pow
	GLOBAL	___asm_f16_pow
.___asm_f16_pow
	push	bc
	push	bc
	ld	hl,6	;const
	add	hl,sp	;l_gintspsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	hl
	ld	hl,0	;const
	call	l_f16_eq
	ld	a,h
	or	l
	jp	z,i_2	;
	ld	hl,15360	;const
	pop	bc
	pop	bc
	pop	bc
	pop	af
	pop	af
	push	bc
	ret


.i_2
	ld	hl,6	;const
	add	hl,sp	;l_gintspsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	hl
	ld	hl,15360	;const
	call	l_f16_eq
	ld	a,h
	or	l
	jp	z,i_5	;
	call	l_gint8sp	;
	pop	bc
	pop	bc
	pop	bc
	pop	af
	pop	af
	push	bc
	ret


.i_5
	ld	hl,6	;const
	add	hl,sp	;l_gintspsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	hl
	ld	hl,48128	;const
	call	l_f16_eq
	ld	a,h
	or	l
	jp	z,i_6	;
	ld	hl,8	;const
	add	hl,sp
	ld	a,(hl)	;l_gint
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	bc,15360	;const
	push	bc
	call	l_f16_div
	pop	bc
	pop	bc
	pop	bc
	pop	af
	pop	af
	push	bc
	ret


.i_6
	ld	hl,8	;const
	add	hl,sp	;l_gintspsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	hl
	ld	hl,0	;const
	call	l_f16_gt
	ld	a,h
	or	l
	jp	z,i_7	;
	ld	hl,6	;const
	add	hl,sp	;l_gintspsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	hl
	ld	hl,14336	;const
	call	l_f16_eq
	ld	a,h
	or	l
	jp	z,i_8	;
	call	l_gint8sp	;
	call	sqrtf16
	pop	bc
	pop	bc
	pop	bc
	pop	af
	pop	af
	push	bc
	ret


.i_8
	ld	hl,6	;const
	add	hl,sp	;l_gintspsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	hl
	ld	hl,47104	;const
	call	l_f16_eq
	ld	a,h
	or	l
	jp	z,i_10	;
	call	l_gint8sp	;
	call	invsqrtf16
	pop	bc
	pop	bc
	pop	bc
	pop	af
	pop	af
	push	bc
	ret


.i_10
	ld	hl,6	;const
	add	hl,sp	;l_gintspsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	hl
	ld	hl,16384	;const
	call	l_f16_eq
	ld	a,h
	or	l
	jp	z,i_11	;
	call	l_gint8sp	;
	call	sqrf16
	pop	bc
	pop	bc
	pop	bc
	pop	af
	pop	af
	push	bc
	ret


.i_11
	ld	hl,6	;const
	add	hl,sp	;l_gintspsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	hl
	ld	hl,49152	;const
	call	l_f16_eq
	ld	a,h
	or	l
	jp	z,i_13	;
	call	l_gint8sp	;
	call	sqrf16
	ld	bc,15360	;const
	push	bc
	call	l_f16_div
	pop	bc
	pop	bc
	pop	bc
	pop	af
	pop	af
	push	bc
	ret


.i_13
	call	l_gint8sp	;
	call	log2f16
	push	hl
	call	l_gint8sp	;
	call	l_f16_mul
	call	exp2f16
	pop	bc
	pop	bc
	pop	bc
	pop	af
	pop	af
	push	bc
	ret


.i_7
	ld	hl,8	;const
	add	hl,sp	;l_gintspsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	hl
	ld	hl,0	;const
	call	l_f16_eq
	ld	a,h
	or	l
	jp	z,i_14	;
	ld	hl,6	;const
	add	hl,sp	;l_gintspsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	hl
	ld	hl,0	;const
	call	l_f16_gt
	ld	a,h
	or	l
	jp	z,i_15	;
	ld	hl,0	;const
	pop	bc
	pop	bc
	pop	bc
	pop	af
	pop	af
	push	bc
	ret


.i_15
	ld	hl,2	;const
	add	hl,sp
	ld	(hl),0
	inc	hl
	ld	(hl),124
	pop	bc
	pop	hl
	push	hl
	push	bc
	pop	bc
	pop	bc
	pop	bc
	pop	af
	pop	af
	push	bc
	ret


.i_14
	ld	hl,6	;const
	add	hl,sp	;l_gintspsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	hl
	ld	hl,16384	;const
	call	l_f16_eq
	ld	a,h
	or	l
	jp	z,i_16	;
	call	l_gint8sp	;
	call	sqrf16
	pop	bc
	pop	bc
	pop	bc
	pop	af
	pop	af
	push	bc
	ret


.i_16
	ld	hl,6	;const
	add	hl,sp	;l_gintspsp
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	hl
	ld	hl,49152	;const
	call	l_f16_eq
	ld	a,h
	or	l
	jp	z,i_17	;
	call	l_gint8sp	;
	call	sqrf16
	ld	bc,15360	;const
	push	bc
	call	l_f16_div
	pop	bc
	pop	bc
	pop	bc
	pop	af
	pop	af
	push	bc
	ret


.i_17
	call	l_gint6sp	;
	push	hl
	call	floorf16
	call	l_f16_ne
	ld	a,h
	or	l
	jp	z,i_18	;
	ld	hl,2	;const
	add	hl,sp
	ld	(hl),255
	inc	hl
	ld	(hl),255
	pop	bc
	pop	hl
	push	hl
	push	bc
	pop	bc
	pop	bc
	pop	bc
	pop	af
	pop	af
	push	bc
	ret


.i_18
	call	l_gint8sp	;
	ld	a,h
	xor	128
	ld	h,a
	call	log2f16
	push	hl
	call	l_gint8sp	;
	call	l_f16_mul
	call	exp2f16
	pop	bc
	push	hl
	call	l_gint6sp	;
	ld	a,-1
	call	l_f16_ldexp
	push	hl
	call	l_gint8sp	;
	ld	a,-1
	call	l_f16_ldexp
	call	floorf16
	call	l_f16_ne
	ld	a,h
	or	l
	jp	z,i_19	;
	pop	hl
	push	hl
	ld	a,h
	xor	128
	ld	h,a
	pop	bc
	push	hl
.i_19
	pop	hl
	push	hl
	pop	bc
	pop	bc
	pop	bc
	pop	af
	pop	af
	push	bc
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
	GLOBAL	sqrf16
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
	GLOBAL	cos
	GLOBAL	tan
	GLOBAL	sin
	GLOBAL	acos
	GLOBAL	asin
	GLOBAL	atan
	GLOBAL	atan2
	GLOBAL	cosh
	GLOBAL	sinh
	GLOBAL	tanh
	GLOBAL	asinh
	GLOBAL	acosh
	GLOBAL	atanh
	GLOBAL	pow
	GLOBAL	sqrt
	GLOBAL	exp
	GLOBAL	log
	GLOBAL	log10
	GLOBAL	floor
	GLOBAL	ceil
	GLOBAL	modf
	GLOBAL	ldexp
	GLOBAL	frexp
	GLOBAL	fabs
	GLOBAL	fmod
	GLOBAL	fmax
	GLOBAL	fmin
	GLOBAL	halfpi
	GLOBAL	pi
	GLOBAL	atof
	GLOBAL	ftoa
	GLOBAL	ftoe
	GLOBAL	fprand
	GLOBAL	fpseed
	GLOBAL	fpclassify
	GLOBAL	asm_f16_pow


; --- End of Scope Defns ---


; --- End of Compilation ---
