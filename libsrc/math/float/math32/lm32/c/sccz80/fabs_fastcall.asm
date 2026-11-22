
	SECTION	code_fp_math32
	PUBLIC	fabs_fastcall
	EXTERN	m32_fabs_fastcall

	defc	fabs_fastcall = m32_fabs_fastcall

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _fabs_fastcall
	defc _fabs_fastcall = m32_fabs_fastcall

