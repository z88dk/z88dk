
	SECTION	code_fp_math32
	PUBLIC	_hypot
	EXTERN	_m32_hypotf

	defc	_hypot = _m32_hypotf
