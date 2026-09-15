
	SECTION	code_fp_math32
	PUBLIC	sinh_fastcall
	EXTERN	_m32_sinhf

	defc	sinh_fastcall = _m32_sinhf

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _sinh_fastcall
	defc _sinh_fastcall = _m32_sinhf

