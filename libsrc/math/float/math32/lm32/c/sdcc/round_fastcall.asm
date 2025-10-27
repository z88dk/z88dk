
	SECTION	code_fp_math32
	PUBLIC	_round_fastcall
	EXTERN	_m32_roundf

	defc	_round_fastcall = _m32_roundf
