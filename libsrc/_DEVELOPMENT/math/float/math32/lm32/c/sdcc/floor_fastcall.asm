
	SECTION	code_fp_math32
	PUBLIC	_floor_fastcall
	EXTERN	_m32_floor_fastcall

	defc	_floor_fastcall = _m32_floor_fastcall
