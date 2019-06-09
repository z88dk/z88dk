	SECTION	code_fp_math32

	PUBLIC	l_f32_invf
	EXTERN	m32_fsinv_fastcall


.l_f32_invf
	pop	bc
	pop	hl
	pop	de
	push	bc
	jp	m32_fsinv_fastcall
