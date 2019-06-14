
	SECTION	code_fp_math32
	PUBLIC	_hypot
	EXTERN	_m32_hypotf_callee

	defc	_hypot = _m32_hypotf_callee
