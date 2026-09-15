
	SECTION	code_fp_math32
	PUBLIC	exp2_fastcall
	EXTERN	_m32_exp2f

	defc	exp2_fastcall = _m32_exp2f

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _exp2_fastcall
	defc _exp2_fastcall = _m32_exp2f

