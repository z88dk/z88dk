
	SECTION	code_fp_math32
	PUBLIC	_modf_callee
	EXTERN	_m32_modff

	defc	_modf_callee = _m32_modff
