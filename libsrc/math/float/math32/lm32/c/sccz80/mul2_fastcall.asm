
	SECTION	code_fp_math32
	PUBLIC	mul2_fastcall
	EXTERN	m32_fsmul2_fastcall

	defc	mul2_fastcall = m32_fsmul2_fastcall

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _mul2_fastcall
	defc _mul2_fastcall = m32_fsmul2_fastcall

