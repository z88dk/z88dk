
	SECTION	code_fp_math32
	PUBLIC	_invsqrt_fastcall
	EXTERN	m32_fsinvsqrt_fastcall

	defc	_invsqrt_fastcall = m32_fsinvsqrt_fastcall
