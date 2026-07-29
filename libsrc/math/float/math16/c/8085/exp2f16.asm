;* * * * *  Small-C/Plus z88dk * * * * *
;  Version: 25141-6b30e0885e-20260716
;
;	Reconstructed for z80 Module Assembler
;
;	Module compile time: Wed Jul 29 12:38:13 2026


	C_LINE	0,"exp2f16.c"

	MODULE	exp2f16_c


	INCLUDE "z80_crt0.hdr"


	EXTERN	saved_hl
	C_LINE	0,"math16.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/compiler.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/proto.h"
	C_LINE	6,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/compiler.h"
	C_LINE	10,"/home/phillip/Z80/z88dk/lib/config/../..//include/stdint.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	17,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	26,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	38,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	44,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	49,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	54,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	59,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	64,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	69,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	74,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	79,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	84,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	89,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	93,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	94,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	95,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	97,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	98,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	99,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	105,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
	C_LINE	110,"/home/phillip/Z80/z88dk/lib/config/../..//include/sys/types.h"
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
	C_LINE	34,"math16.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/math.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/limits.h"
	C_LINE	7,"/home/phillip/Z80/z88dk/lib/config/../..//include/math.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/float.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/math.h"
	C_LINE	6,"/home/phillip/Z80/z88dk/lib/config/../..//include/float.h"
	C_LINE	8,"/home/phillip/Z80/z88dk/lib/config/../..//include/math.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	30,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	31,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	33,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	34,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	36,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	37,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	38,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	39,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	41,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	42,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	43,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	44,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	45,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	46,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
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
	C_LINE	137,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	138,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	139,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	140,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	142,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	143,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	144,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	147,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	148,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	149,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	150,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	151,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	152,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	153,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	156,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	157,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	163,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	164,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	168,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	169,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	172,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	173,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_math16.h"
	C_LINE	34,"/home/phillip/Z80/z88dk/lib/config/../..//include/math.h"
	C_LINE	0,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	39,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	41,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	42,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	43,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	44,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	45,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	46,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	49,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	50,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	51,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	52,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	53,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	54,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	57,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	58,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	64,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	65,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	66,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	73,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	74,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	80,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	81,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	83,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	89,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	90,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	91,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	92,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	99,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	100,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	103,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	104,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	105,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	108,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	109,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	123,"/home/phillip/Z80/z88dk/lib/config/../..//include/math/math_genmath.h"
	C_LINE	49,"/home/phillip/Z80/z88dk/lib/config/../..//include/math.h"
	C_LINE	35,"math16.h"
	C_LINE	65,"exp2f16.c"
	C_LINE	67,"exp2f16.c"
	C_LINE	69,"exp2f16.c"
	SECTION	code_compiler

; Function exp2f16 flags 0x00000288 __smallc __z88dk_fastcall 
; _Float16 half_texp2f16(_Float16 x)
; parameter '_Float16 x' at sp+2 size(2)
	C_LINE	70,"exp2f16.c::exp2f16::0::0"
.exp2f16
	GLOBAL	_exp2f16
._exp2f16
	GLOBAL	___exp2f16
.___exp2f16
	push	hl
	push	bc
	ld	de,sp+2
	ld	hl,(de)	;l_gint
	push	hl
	ld	hl,19455	;const
	call	l_f16_gt
	ld	a,h
	or	l
	jp	z,i_2	;
	ld	hl,31743	;const
	pop	bc
	pop	bc
	ret


.i_2
	ld	de,sp+2
	ld	hl,(de)	;l_gint
	push	hl
	ld	hl,51968	;const
	call	l_f16_lt
	ld	a,h
	or	l
	jp	z,i_5	;
	ld	hl,0	;const
	pop	bc
	pop	bc
	ret


.i_5
	ld	de,sp+2
	ld	hl,(de)	;l_gint
	push	hl
	ld	hl,0	;const
	call	l_f16_eq
	ld	a,h
	or	l
	jp	z,i_9	;
	ld	hl,15360	;const
	pop	bc
	pop	bc
	ret


.i_9
	ld	de,sp+2
	ld	hl,(de)	;l_gint
	push	hl
	ld	hl,14336	;const
	call	l_f16_add
	call	floorf16
	pop	bc
	push	hl
	ld	de,sp+2
	ld	hl,(de)	;l_gint
	push	hl
	ld	de,sp+2
	ld	hl,(de)	;l_gint
	call	l_f16_sub
	pop	de
	pop	bc
	push	hl
	push	de
	ld	de,sp+2
	ld	hl,(de)	;l_gint
	push	hl
	ld	hl,_f16_coeff_exp2
	push	hl
	ld	hl,5	;const
	push	hl
	call	polyf16
	pop	bc
	pop	bc
	pop	bc
	push	hl
	ld	de,sp+2
	ld	hl,(de)	;l_gint
	call	l_f16_f2sint
	push	hl
	call	ldexpf16
	pop	bc
	pop	bc
	pop	bc
	pop	bc
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
	GLOBAL	_f16_coeff_exp2


; --- End of Scope Defns ---


; --- End of Compilation ---
