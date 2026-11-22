
	SECTION	code_fp_math32
	PUBLIC	exp_fastcall
	EXTERN	_m32_expf

	defc	exp_fastcall = _m32_expf

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _exp_fastcall
	defc _exp_fastcall = _m32_expf

