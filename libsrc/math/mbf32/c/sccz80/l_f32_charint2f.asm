
	MODULE	l_f32_uchar2f
	SECTION	code_fp_mbf32

	PUBLIC	l_f32_uchar2f
	PUBLIC	l_f32_uint2f
	PUBLIC	l_f32_schar2f
	PUBLIC	l_f32_sint2f

	EXTERN	___mbf32_BNORM
	EXTERN	___mbf32_FPREG
	EXTERN	___mbf32_FPEXP
	EXTERN	___mbf32_FPSIGN
	EXTERN	___mbf32_return
	EXTERN	l_neg_hl
	EXTERN	msbios

; Convert signed char/int in l to floating point value in dehl
l_f32_uchar2f:
l_f32_uint2f:
	ld	a,128
	jr	not_negative
l_f32_schar2f:
l_f32_sint2f:
	ld	a,128
	bit	7,h
	jr	z,not_negative
	call	l_neg_hl
	xor	a
not_negative:
	ld	(___mbf32_FPSIGN),a
	ex	de,hl
	ld	c,0
	ld	a,24 + 128
	ld	(___mbf32_FPEXP),a
	ld	b,0
	push	ix
	ld	ix,___mbf32_BNORM
	call	msbios
	jp	___mbf32_return

