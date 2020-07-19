
	MODULE	l_f32_uchar2f
	SECTION	code_fp_dai32

	PUBLIC	l_f32_ulong2f
	PUBLIC	l_f32_slong2f

	EXTERN	___dai32_BNORM
	EXTERN	___dai32_FPREG
	EXTERN	___dai32_FPEXP
	EXTERN	___dai32_FPSIGN
	EXTERN	___dai32_return
	EXTERN	l_long_neg

; Convert signed char/long in l to floating polong value in dehl
l_f32_ulong2f:
	ld	a,128
	jr	not_negative
l_f32_slong2f:
	ld	a,d
	rla
	ld	a,128
	jp	nc,not_negative
	call	l_long_neg
	xor	a
not_negative:
	ld	(___dai32_FPSIGN),a
	ex	de,hl
	ld	c,l		;TODO: we drop the MSB
	ld	a,24 + 128
	ld	(___dai32_FPEXP),a
	ld	b,0
	call	___dai32_BNORM

	jp	___dai32_return

