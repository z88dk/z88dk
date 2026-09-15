
	SECTION	code_fp_math32
	PUBLIC	exp10_fastcall
	EXTERN	_m32_exp10f

	defc	exp10_fastcall = _m32_exp10f

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _exp10_fastcall
	defc _exp10_fastcall = _m32_exp10f

