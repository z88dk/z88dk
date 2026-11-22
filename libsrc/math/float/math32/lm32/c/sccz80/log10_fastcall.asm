
	SECTION	code_fp_math32
	PUBLIC	log10_fastcall
	EXTERN	_m32_log10f

	defc	log10_fastcall = _m32_log10f

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _log10_fastcall
	defc _log10_fastcall = _m32_log10f

