
	SECTION	code_fp_math32
	PUBLIC	mul10u_fastcall
	EXTERN	m32_fsmul10u_fastcall

	defc	mul10u_fastcall = m32_fsmul10u_fastcall

	; Link-time C-ABI linkage aliases onto the fastcall/core implementation.
	; Exported for both Classic and Newlib.
	PUBLIC _mul10u_fastcall
	defc _mul10u_fastcall = m32_fsmul10u_fastcall

