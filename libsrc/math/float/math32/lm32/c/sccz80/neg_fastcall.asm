
	SECTION	code_fp_math32
	PUBLIC	neg_fastcall
	EXTERN	m32_fsneg

	defc	neg_fastcall = m32_fsneg

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _neg_fastcall
	defc _neg_fastcall = m32_fsneg

