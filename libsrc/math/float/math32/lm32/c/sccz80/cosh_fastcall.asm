
	SECTION	code_fp_math32
	PUBLIC	cosh_fastcall
	EXTERN	_m32_coshf

	defc	cosh_fastcall = _m32_coshf

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _cosh_fastcall
	defc _cosh_fastcall = _m32_coshf

