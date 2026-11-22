
	SECTION	code_fp_math32
	PUBLIC	_sin_fastcall
	EXTERN	_m32_sinf

	defc	_sin_fastcall = _m32_sinf
