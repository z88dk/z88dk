
	SECTION	code_fp_math32
	PUBLIC	div2_fastcall
	EXTERN	m32_fsdiv2_fastcall

	defc	div2_fastcall = m32_fsdiv2_fastcall

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _div2_fastcall
	defc _div2_fastcall = m32_fsdiv2_fastcall

