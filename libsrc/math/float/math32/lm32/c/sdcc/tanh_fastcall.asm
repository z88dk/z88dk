
	SECTION	code_fp_math32
	PUBLIC	_tanh_fastcall
	EXTERN	_m32_tanhf

	defc	_tanh_fastcall = _m32_tanhf
