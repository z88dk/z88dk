
	SECTION	code_fp_math32
	PUBLIC	ceil_fastcall
	EXTERN	m32_ceil_fastcall

	defc	ceil_fastcall = m32_ceil_fastcall

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _ceil_fastcall
	defc _ceil_fastcall = m32_ceil_fastcall

