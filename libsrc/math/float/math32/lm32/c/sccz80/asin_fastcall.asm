
	SECTION	code_fp_math32
	PUBLIC	asin_fastcall
	EXTERN	_m32_asinf

	defc	asin_fastcall = _m32_asinf

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _asin_fastcall
	defc _asin_fastcall = _m32_asinf

