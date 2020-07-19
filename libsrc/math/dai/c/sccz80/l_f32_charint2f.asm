
	MODULE	l_f32_uchar2f
	SECTION	code_fp_dai32

	PUBLIC	l_f32_uchar2f
	PUBLIC	l_f32_uint2f
	PUBLIC	l_f32_schar2f
	PUBLIC	l_f32_sint2f

	EXTERN	___dai32_BNORM
	EXTERN	___dai32_FPREG
	EXTERN	___dai32_FPEXP
	EXTERN	___dai32_FPSIGN
	EXTERN	___dai32_return
	EXTERN	l_neg_hl

; Convert signed char/int in l to floating point value in dehl
l_f32_uchar2f:
l_f32_uint2f:
	ld	a,128
	jr	not_negative
l_f32_schar2f:
l_f32_sint2f:
	ld	a,h
	rla
	ld	a,128
	jr	nc,not_negative
	call	l_neg_hl
	xor	a
not_negative:
	ld	(___dai32_FPSIGN),a
	ex	de,hl
	ld	c,0
	ld	a,24 + 128
	ld	(___dai32_FPEXP),a
	ld	b,0
	call	___dai32_BNORM
	jp	___dai32_return

