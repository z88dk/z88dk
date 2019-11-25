
	SECTION	code_fp_math32
	PUBLIC	l_f32_invf
	EXTERN	m32_fsinv_fastcall

	defc	l_f32_invf = m32_fsinv_fastcall
