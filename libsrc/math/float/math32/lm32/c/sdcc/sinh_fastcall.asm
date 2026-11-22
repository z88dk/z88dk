
	SECTION	code_fp_math32
	PUBLIC	_sinh_fastcall
	EXTERN	_m32_sinhf

	defc	_sinh_fastcall = _m32_sinhf
