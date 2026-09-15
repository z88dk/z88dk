
	SECTION	code_fp_math32
	PUBLIC	cos_fastcall
	EXTERN	_m32_cosf

	defc	cos_fastcall = _m32_cosf

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _cos_fastcall
	defc _cos_fastcall = _m32_cosf

