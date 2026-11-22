
	SECTION	code_fp_math32
	PUBLIC	atanh_fastcall
	EXTERN	_m32_atanhf

	defc	atanh_fastcall = _m32_atanhf

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _atanh_fastcall
	defc _atanh_fastcall = _m32_atanhf

