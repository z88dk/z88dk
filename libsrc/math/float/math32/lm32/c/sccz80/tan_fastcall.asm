
	SECTION	code_fp_math32
	PUBLIC	tan_fastcall
	EXTERN	_m32_tanf

	defc	tan_fastcall = _m32_tanf

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _tan_fastcall
	defc _tan_fastcall = _m32_tanf

