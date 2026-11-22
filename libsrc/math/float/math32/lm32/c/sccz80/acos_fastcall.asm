
	SECTION	code_fp_math32
	PUBLIC	acos_fastcall
	EXTERN	_m32_acosf

	defc	acos_fastcall = _m32_acosf

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _acos_fastcall
	defc _acos_fastcall = _m32_acosf

