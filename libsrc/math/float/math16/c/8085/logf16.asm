;* * * * *  Small-C/Plus z88dk * * * * *
;  Version: 25461-415806f08c-20260813
;
;	Reconstructed for z80 Module Assembler
;
;	Module compile time: Tue Sep  8 21:16:04 2026



	C_LINE	0,"logf16.c"

	MODULE	logf16_c


	INCLUDE "z80_crt0.hdr"


	EXTERN	saved_hl
	C_LINE	37,"logf16.c"
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
	C_LINE	45,"logf16.c"
	C_LINE	47,"logf16.c"
	C_LINE	49,"logf16.c"
	SECTION	code_compiler

; Function logf16 flags 0x00000288 __smallc __z88dk_fastcall 
; _Float16 half_tlogf16(_Float16 x)
; parameter '_Float16 x' at sp+2 size(2)
	C_LINE	50,"logf16.c::logf16::0::0"
.logf16
	GLOBAL	_logf16
._logf16
	GLOBAL	___logf16
.___logf16
	push	hl
	push	bc
	push	bc
	push	bc
	push	bc
	push	bc
	ld	de,sp+10
	ld	hl,(de)	;l_gint
	push	hl
	ld	hl,0	;const
	call	l_f16_le
	ld	a,h
	or	l
	jp	z,i_2	;
	ld	hl,8	;const
	add	hl,sp
	push	hl
	ld	de,sp+12
	ld	hl,(de)	;l_gint
	push	hl
	ld	hl,0	;const
	call	l_f16_eq
	ld	a,h
	or	l
	jp	z,i_4	;
	ld	hl,64512	;const
	jp	i_5	;
.i_4
	ld	hl,65535	;const
.i_5
	pop	de
	ld	(de),hl	;l_pint
	ld	de,sp+8
	ld	hl,(de)	;l_gint
	ex	de,hl
	ld	hl,12	;const
	add	hl,sp
	ld	sp,hl
	ex	de,hl
	ret


.i_2
	ld	de,sp+10
	push	de
	ld	hl,(de)	;l_gint
	push	hl
	ld	hl,4	;const
	add	hl,sp
	push	hl
	call	frexpf16
	pop	bc
	pop	bc
	pop	de
	ld	(de),hl	;l_pint
	ld	de,sp+10
	ld	hl,(de)	;l_gint
	push	hl
	ld	hl,14760	;const
	call	l_f16_lt
	ld	a,h
	or	l
	jp	z,i_6	;
	pop	hl
	dec	hl
	push	hl
	ld	de,sp+10
	push	de
	ld	hl,(de)	;l_gint
	call	mul2f16
	push	hl
	ld	hl,15360	;const
	call	l_f16_sub
	pop	de
	ld	(de),hl	;l_pint
	jp	i_9	;EOS
.i_6
	ld	de,sp+10
	push	de
	ld	hl,(de)	;l_gint
	push	hl
	ld	hl,15360	;const
	call	l_f16_sub
	pop	de
	ld	(de),hl	;l_pint
.i_9
	ld	hl,4	;const
	add	hl,sp
	push	hl
	ld	de,sp+12
	ld	hl,(de)	;l_gint
	call	sqrf16
	pop	de
	ld	(de),hl	;l_pint
	ld	hl,6	;const
	add	hl,sp
	push	hl
	ld	de,sp+12
	ld	hl,(de)	;l_gint
	push	hl
	ld	hl,(_f16_coeff_log)
	push	hl
	ld	hl,9	;const
	push	hl
	call	polyf16
	pop	bc
	pop	bc
	pop	bc
	push	hl
	ld	de,sp+8
	ld	hl,(de)	;l_gint
	call	l_f16_mul
	pop	de
	ld	(de),hl	;l_pint
	pop	hl
	push	hl
	call	l_f16_sint2f
	pop	de
	pop	bc
	push	hl
	push	de
	ld	de,sp+6
	push	de
	ld	hl,(de)	;l_gint
	push	hl
	ld	de,sp+6
	ld	hl,(de)	;l_gint
	push	hl
	ld	hl,35572	;const
	call	l_f16_mul
	call	l_f16_add
	pop	de
	ld	(de),hl	;l_pint
	ld	de,sp+6
	push	de
	ld	hl,(de)	;l_gint
	push	hl
	ld	de,sp+8
	ld	hl,(de)	;l_gint
	call	div2f16
	call	l_f16_sub
	pop	de
	ld	(de),hl	;l_pint
	ld	hl,4	;const
	add	hl,sp
	push	hl
	ld	de,sp+12
	ld	hl,(de)	;l_gint
	push	hl
	ld	de,sp+10
	ld	hl,(de)	;l_gint
	call	l_f16_add
	pop	de
	ld	(de),hl	;l_pint
	ld	de,sp+4
	push	de
	ld	hl,(de)	;l_gint
	push	hl
	ld	de,sp+6
	ld	hl,(de)	;l_gint
	push	hl
	ld	hl,14732	;const
	call	l_f16_mul
	call	l_f16_add
	pop	de
	ld	(de),hl	;l_pint
	ld	de,sp+4
	ld	hl,(de)	;l_gint
	ex	de,hl
	ld	hl,12	;const
	add	hl,sp
	ld	sp,hl
	ex	de,hl
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
	GLOBAL	_f16_coeff_log


; --- End of Scope Defns ---


; --- End of Compilation ---
