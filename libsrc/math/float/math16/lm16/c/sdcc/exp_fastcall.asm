
	SECTION code_clib
	SECTION	code_fp_math16
	PUBLIC	_expf16_fastcall
	EXTERN	expf16

	defc	_expf16_fastcall = expf16
