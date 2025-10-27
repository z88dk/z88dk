
	SECTION	code_fp_math32
	PUBLIC	_fmod
	EXTERN	_m32_fmodf

	defc	_fmod = _m32_fmodf
