
	SECTION	code_fp_math32
	PUBLIC	tanh_fastcall
	EXTERN	_m32_tanhf

	defc	tanh_fastcall = _m32_tanhf
