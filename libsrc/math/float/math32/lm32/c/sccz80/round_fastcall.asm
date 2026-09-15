
	SECTION	code_fp_math32
	PUBLIC	round_fastcall
	EXTERN	_m32_roundf

	defc	round_fastcall = _m32_roundf

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _round_fastcall
	defc _round_fastcall = _m32_roundf

