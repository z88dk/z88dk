
	SECTION	code_fp_math32
	PUBLIC	_frexp_callee
	EXTERN	_m32_frexpf_callee

	defc	_frexp_callee = _m32_frexpf_callee
