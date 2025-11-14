
	SECTION	code_fp_math32
	PUBLIC	_cos_fastcall
	EXTERN	_m32_cosf

	defc	_cos_fastcall = _m32_cosf
