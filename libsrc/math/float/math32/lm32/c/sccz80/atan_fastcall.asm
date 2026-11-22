
	SECTION	code_fp_math32
	PUBLIC	atan_fastcall
	EXTERN	_m32_atanf

	defc	atan_fastcall = _m32_atanf

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _atan_fastcall
	defc _atan_fastcall = _m32_atanf

