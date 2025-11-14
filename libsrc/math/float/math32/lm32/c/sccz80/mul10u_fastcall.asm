
	SECTION	code_fp_math32
	PUBLIC	mul10u_fastcall
	EXTERN	m32_fsmul10u_fastcall

	defc	mul10u_fastcall = m32_fsmul10u_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _mul10u_fastcall
defc _mul10u_fastcall = m32_fsmul10u_fastcall
ENDIF

