
	SECTION	code_fp_math32
	PUBLIC	_atanh_fastcall
	EXTERN	_m32_atanhf

	defc	_atanh_fastcall = _m32_atanhf
