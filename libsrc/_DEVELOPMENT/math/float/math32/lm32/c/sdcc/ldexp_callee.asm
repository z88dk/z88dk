
	SECTION	code_fp_math32
	PUBLIC	_ldexp_callee
	EXTERN	_m32_ldexpf_callee

	defc	_ldexp_callee = _m32_ldexpf_callee
