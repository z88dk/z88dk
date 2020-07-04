
	SECTION	code_fp_math16
	PUBLIC	_sin_fastcall
	EXTERN	_m16_sinf

	defc	_sin_fastcall = _m16_sinf
