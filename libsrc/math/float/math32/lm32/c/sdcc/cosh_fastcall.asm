
	SECTION	code_fp_math32
	PUBLIC	_cosh_fastcall
	EXTERN	_m32_coshf

	defc	_cosh_fastcall = _m32_coshf
