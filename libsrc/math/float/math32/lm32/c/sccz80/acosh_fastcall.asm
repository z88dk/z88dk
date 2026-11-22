
	SECTION	code_fp_math32
	PUBLIC	acosh_fastcall
	EXTERN	_m32_acoshf

	defc	acosh_fastcall = _m32_acoshf

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _acosh_fastcall
	defc _acosh_fastcall = _m32_acoshf

