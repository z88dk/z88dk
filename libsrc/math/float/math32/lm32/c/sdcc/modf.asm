
	SECTION	code_fp_math32
	PUBLIC	_modf
	EXTERN	_m32_modff

	defc	_modf = _m32_modff
