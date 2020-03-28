
	SECTION	code_fp_math32
	PUBLIC	mul10u
	EXTERN	m32_fsmul10u_fastcall

	defc	mul10u = m32_fsmul10u_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _mul10u
EXTERN cm32_sdcc_fsmul10u
defc _mul10u = cm32_sdcc_fsmul10u
ENDIF

