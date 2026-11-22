
	SECTION	code_fp_math32
	PUBLIC	sin_fastcall
	EXTERN	_m32_sinf

	defc	sin_fastcall = _m32_sinf

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _sin_fastcall
	defc _sin_fastcall = _m32_sinf

