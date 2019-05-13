
	SECTION	code_fp_math32
	PUBLIC	sin_fastcall
	EXTERN	_m32_sinf

	defc	sin_fastcall = _m32_sinf
