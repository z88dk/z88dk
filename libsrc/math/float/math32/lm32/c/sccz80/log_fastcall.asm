
	SECTION	code_fp_math32
	PUBLIC	log_fastcall
	EXTERN	_m32_logf

	defc	log_fastcall = _m32_logf

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _log_fastcall
	defc _log_fastcall = _m32_logf

