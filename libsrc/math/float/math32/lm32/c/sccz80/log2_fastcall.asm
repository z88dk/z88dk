
	SECTION	code_fp_math32
	PUBLIC	log2_fastcall
	EXTERN	_m32_log2f

	defc	log2_fastcall = _m32_log2f

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _log2_fastcall
	defc _log2_fastcall = _m32_log2f

