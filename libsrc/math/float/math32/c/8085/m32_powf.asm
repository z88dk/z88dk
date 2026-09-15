;* * * * *  Small-C/Plus z88dk * * * * *
;  Version: 25884-473c5c9c7b-20260914
;
;	Reconstructed for z80 Module Assembler
;
;	Module compile time: Tue Sep 15 03:36:52 2026


	C_LINE	0,"m32_powf.c"

	MODULE	m32_powf_c


	INCLUDE "z80_crt0.hdr"


	EXTERN	saved_hl
	C_LINE	0,"m32_math.h"
	C_LINE	34,"m32_math.h"
	C_LINE	35,"m32_math.h"
	C_LINE	37,"m32_math.h"
	C_LINE	53,"m32_math.h"
	C_LINE	54,"m32_math.h"
	C_LINE	55,"m32_math.h"
	C_LINE	56,"m32_math.h"
	C_LINE	57,"m32_math.h"
	C_LINE	58,"m32_math.h"
	C_LINE	59,"m32_math.h"
	C_LINE	62,"m32_math.h"
	C_LINE	63,"m32_math.h"
	C_LINE	64,"m32_math.h"
	C_LINE	65,"m32_math.h"
	C_LINE	66,"m32_math.h"
	C_LINE	67,"m32_math.h"
	C_LINE	70,"m32_math.h"
	C_LINE	71,"m32_math.h"
	C_LINE	72,"m32_math.h"
	C_LINE	73,"m32_math.h"
	C_LINE	74,"m32_math.h"
	C_LINE	75,"m32_math.h"
	C_LINE	76,"m32_math.h"
	C_LINE	79,"m32_math.h"
	C_LINE	80,"m32_math.h"
	C_LINE	81,"m32_math.h"
	C_LINE	82,"m32_math.h"
	C_LINE	83,"m32_math.h"
	C_LINE	84,"m32_math.h"
	C_LINE	87,"m32_math.h"
	C_LINE	88,"m32_math.h"
	C_LINE	89,"m32_math.h"
	C_LINE	90,"m32_math.h"
	C_LINE	91,"m32_math.h"
	C_LINE	92,"m32_math.h"
	C_LINE	93,"m32_math.h"
	C_LINE	94,"m32_math.h"
	C_LINE	95,"m32_math.h"
	C_LINE	96,"m32_math.h"
	C_LINE	32,"m32_powf.c"
	C_LINE	34,"m32_powf.c"
	SECTION	code_compiler

; Function m32_powf flags 0x00000200 __smallc 
; double m32_powf(double x, double y)
; parameter 'double y' at sp+2 size(4)
; parameter 'double x' at sp+6 size(4)
	C_LINE	35,"m32_powf.c::m32_powf::0::0"
._m32_powf
	ld	hl,65520	;const
	add	hl,sp
	ld	sp,hl
	ld	de,sp+18
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_eq
	ld	a,h
	or	l
	jp	z,i_2	;
	ld	hl,0	;const
	ld	de,16256
	ld	b,h
	ld	c,l
	ld	hl,16	;const
	add	hl,sp
	ld	sp,hl
	ld	h,b
	ld	l,c
	ret


.i_2
	ld	de,sp+18
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	de,16256
	call	l_f32_eq
	ld	a,h
	or	l
	jp	z,i_3	;
	ld	de,sp+22
	ex	de,hl
	call	l_glong
	ld	b,h
	ld	c,l
	ld	hl,16	;const
	add	hl,sp
	ld	sp,hl
	ld	h,b
	ld	l,c
	ret


.i_3
	ld	de,sp+18
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	de,49024
	call	l_f32_eq
	ld	a,h
	or	l
	jp	z,i_4	;
	ld	de,sp+22
	ex	de,hl
	call	l_glong
	ld	bc,16256
	push	bc
	ld	bc,0
	push	bc
	call	l_f32_div
	ld	b,h
	ld	c,l
	ld	hl,16	;const
	add	hl,sp
	ld	sp,hl
	ld	h,b
	ld	l,c
	ret


.i_4
	ld	de,sp+22
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_gt
	ld	a,h
	or	l
	jp	z,i_5	;
	ld	de,sp+18
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	de,16128
	call	l_f32_eq
	ld	a,h
	or	l
	jp	z,i_6	;
	ld	de,sp+22
	ex	de,hl
	call	l_glong
	call	_m32_sqrtf
	ld	b,h
	ld	c,l
	ld	hl,16	;const
	add	hl,sp
	ld	sp,hl
	ld	h,b
	ld	l,c
	ret


.i_6
	ld	de,sp+18
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	de,48896
	call	l_f32_eq
	ld	a,h
	or	l
	jp	z,i_7	;
	ld	de,sp+22
	ex	de,hl
	call	l_glong
	call	_m32_invsqrtf
	ld	b,h
	ld	c,l
	ld	hl,16	;const
	add	hl,sp
	ld	sp,hl
	ld	h,b
	ld	l,c
	ret


.i_7
	ld	de,sp+18
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	de,16384
	call	l_f32_eq
	ld	a,h
	or	l
	jp	z,i_8	;
	ld	de,sp+22
	ex	de,hl
	call	l_glong
	call	_m32_sqrf
	ld	b,h
	ld	c,l
	ld	hl,16	;const
	add	hl,sp
	ld	sp,hl
	ld	h,b
	ld	l,c
	ret


.i_8
	ld	de,sp+18
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	de,49152
	call	l_f32_eq
	ld	a,h
	or	l
	jp	z,i_9	;
	ld	de,sp+22
	ex	de,hl
	call	l_glong
	call	_m32_sqrf
	ld	bc,16256
	push	bc
	ld	bc,0
	push	bc
	call	l_f32_div
	ld	b,h
	ld	c,l
	ld	hl,16	;const
	add	hl,sp
	ld	sp,hl
	ld	h,b
	ld	l,c
	ret


.i_9
	ld	hl,65516	;const
	add	hl,sp
	ld	sp,hl
	ld	hl,12	;const
	add	hl,sp
	push	hl
	ld	de,sp+40
	ex	de,hl
	call	l_glong2sp
	ld	hl,22	;const
	add	hl,sp
	push	hl
	call	_m32_modff
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	call	l_plong
	ld	de,sp+12
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_eq
	ld	a,h
	or	l
	jp	z,i_10	;
	ld	hl,0	;const
	add	hl,sp
	push	hl
	ld	de,sp+18
	ex	de,hl
	call	l_glong
	call	l_f32_f2slong
	pop	bc
	call	l_plong
	ld	de,sp+0
	ex	de,hl
	call	l_glong
	ld	a,d
	rla
	jp	nc,i_11	;
	ld	de,sp+0
	ex	de,hl
	push	hl
	call	l_glong
	call	l_long_neg
	pop	bc
	call	l_plong
.i_11
	ld	de,sp+0
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	de,1
	call	l_long_le
	jp	nc,i_12	;
	ld	hl,8	;const
	add	hl,sp
	xor	a
	ld	(hl),a
	inc	hl
	ld	(hl),a
	inc	hl
	ld	(hl),128
	inc	hl
	ld	(hl),63
	ld	de,sp+42
	ex	de,hl
	call	l_glong2sp
	ld	hl,8	;const
	add	hl,sp
	push	hl
	ld	de,sp+6
	ex	de,hl
	call	l_glong
	pop	bc
	call	l_plong
.i_13
	ld	de,sp+8
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_long_gt
	jp	nc,i_14	;
	ld	hl,8	;const
	add	hl,sp
	ld	a,(hl)
	and	1
	jp	z,i_15	;
	ld	de,sp+12
	ex	de,hl
	push	hl
	call	l_glong2sp
	ld	de,sp+6
	ex	de,hl
	call	l_glong
	call	l_f32_mul
	pop	bc
	call	l_plong
.i_15
	ld	de,sp+8
	ex	de,hl
	push	hl
	call	l_glong2sp
	ld	l,1
	call	l_long_asr
	pop	bc
	call	l_plong
	ld	de,sp+8
	ex	de,hl
	call	l_glong
	ld	a,h
	or	l
	or	d
	or	e
	jp	z,i_16	;
	ld	de,sp+0
	ex	de,hl
	push	hl
	call	l_glong2sp
	ld	de,sp+6
	ex	de,hl
	call	l_glong
	call	l_f32_mul
	pop	bc
	call	l_plong
	jp	i_13	;EOS
.i_14
	pop	bc
	pop	bc
	ld	de,sp+16
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_lt
	ld	a,h
	or	l
	jp	z,i_17	;
	ld	de,sp+8
	ex	de,hl
	call	l_glong
	ld	bc,16256
	push	bc
	ld	bc,0
	push	bc
	call	l_f32_div
	jp	i_18	;
.i_17
	ld	de,sp+8
	ex	de,hl
	call	l_glong
.i_18
	ld	b,h
	ld	c,l
	ld	hl,36	;const
	add	hl,sp
	ld	sp,hl
	ld	h,b
	ld	l,c
	ret


.i_12
	ld	hl,20	;const
	add	hl,sp
	ld	sp,hl
	ld	de,sp+22
	ex	de,hl
	call	l_glong
	call	_m32_logf
	push	de
	push	hl
	ld	de,sp+22
	ex	de,hl
	call	l_glong
	call	l_f32_mul
	call	_m32_expf
	ld	b,h
	ld	c,l
	ld	hl,16	;const
	add	hl,sp
	ld	sp,hl
	ld	h,b
	ld	l,c
	ret


.i_5
	ld	de,sp+22
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_eq
	ld	a,h
	or	l
	jp	z,i_19	;
	ld	de,sp+18
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_gt
	ld	a,h
	or	l
	jp	z,i_20	;
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	ld	b,h
	ld	c,l
	ld	hl,16	;const
	add	hl,sp
	ld	sp,hl
	ld	h,b
	ld	l,c
	ret


.i_20
	ld	hl,12	;const
	add	hl,sp
	xor	a
	ld	(hl),a
	inc	hl
	ld	(hl),a
	inc	hl
	ld	(hl),128
	inc	hl
	ld	(hl),127
	ld	de,sp+12
	ex	de,hl
	call	l_glong
	ld	b,h
	ld	c,l
	ld	hl,16	;const
	add	hl,sp
	ld	sp,hl
	ld	h,b
	ld	l,c
	ret


.i_19
	ld	de,sp+18
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	de,16384
	call	l_f32_eq
	ld	a,h
	or	l
	jp	z,i_21	;
	ld	de,sp+22
	ex	de,hl
	call	l_glong
	call	_m32_sqrf
	ld	b,h
	ld	c,l
	ld	hl,16	;const
	add	hl,sp
	ld	sp,hl
	ld	h,b
	ld	l,c
	ret


.i_21
	ld	de,sp+18
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	de,49152
	call	l_f32_eq
	ld	a,h
	or	l
	jp	z,i_22	;
	ld	de,sp+22
	ex	de,hl
	call	l_glong
	call	_m32_sqrf
	ld	bc,16256
	push	bc
	ld	bc,0
	push	bc
	call	l_f32_div
	ld	b,h
	ld	c,l
	ld	hl,16	;const
	add	hl,sp
	ld	sp,hl
	ld	h,b
	ld	l,c
	ret


.i_22
	ld	hl,4	;const
	add	hl,sp
	push	hl
	ld	de,sp+20
	ex	de,hl
	call	l_glong2sp
	ld	hl,14	;const
	add	hl,sp
	push	hl
	call	_m32_modff
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	call	l_plong
	ld	de,sp+4
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_ne
	ld	a,h
	or	l
	jp	z,i_23	;
	ld	hl,12	;const
	add	hl,sp
	ld	(hl),255
	inc	hl
	ld	(hl),255
	inc	hl
	ld	(hl),255
	inc	hl
	ld	(hl),255
	ld	de,sp+12
	ex	de,hl
	call	l_glong
	ld	b,h
	ld	c,l
	ld	hl,16	;const
	add	hl,sp
	ld	sp,hl
	ld	h,b
	ld	l,c
	ret


.i_23
	ld	hl,0	;const
	add	hl,sp
	push	hl
	ld	de,sp+24
	ex	de,hl
	call	l_glong
	ld	a,d
	xor	128
	ld	d,a
	call	_m32_logf
	push	de
	push	hl
	ld	de,sp+24
	ex	de,hl
	call	l_glong
	call	l_f32_mul
	call	_m32_expf
	pop	bc
	call	l_plong
	ld	de,sp+8
	ex	de,hl
	call	l_glong2sp
	ld	hl,0	;const
	ld	de,16384
	push	de
	push	hl
	call	_m32_fmodf
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	push	de
	push	hl
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	call	l_f32_ne
	ld	a,h
	or	l
	jp	z,i_24	;
	ld	de,sp+0
	ex	de,hl
	push	hl
	call	l_glong
	ld	a,d
	xor	128
	ld	d,a
	pop	bc
	call	l_plong
.i_24
	ld	de,sp+0
	ex	de,hl
	call	l_glong
	ld	b,h
	ld	c,l
	ld	hl,16	;const
	add	hl,sp
	ld	sp,hl
	ld	h,b
	ld	l,c
	ret


	SECTION	bss_compiler
	SECTION	code_compiler
; --- Start of Optimiser additions ---
	defc	i_16 = i_13
	defc	i_10 = i_12


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


; --- End of Scope Defns ---


; --- End of Compilation ---
