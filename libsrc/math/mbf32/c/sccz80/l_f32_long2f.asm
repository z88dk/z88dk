
	MODULE	l_f32_uchar2f
	SECTION	code_fp_mbfs

	PUBLIC	l_f32_ulong2f
	PUBLIC	l_f32_slong2f

	EXTERN	___mbfs_BNORM
	EXTERN	___mbfs_FPREG
	EXTERN	___mbfs_FPEXP
	EXTERN	___mbfs_FPSIGN
	EXTERN	___mbfs_return
	EXTERN	l_long_neg
	EXTERN	msbios

; Convert signed char/long in l to floating polong value in dehl
l_f32_ulong2f:
	ld	a,128
	jr	not_negative
l_f32_slong2f:
	ld	a,128
	bit	7,d
	jr	z,not_negative
	call	l_long_neg
	xor	a
not_negative:
	ld	(___mbfs_FPSIGN),a
	ex	de,hl
	ld	c,l		;TODO: we drop the MSB
	ld	a,24 + 128
	ld	(___mbfs_FPEXP),a
	ld	b,0
	push	ix
	ld	ix,___mbfs_BNORM
	call	msbios
	jp	___mbfs_return

