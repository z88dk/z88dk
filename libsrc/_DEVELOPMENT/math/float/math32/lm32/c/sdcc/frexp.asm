
	SECTION	code_fp_math32
	PUBLIC	_frexp
	EXTERN	_m32_frexpf

	defc	_frexp = _m32_frexpf
