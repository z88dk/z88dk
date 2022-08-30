
	SECTION	code_fp_math32
	PUBLIC	mul2
	EXTERN	m32_fsmul2_fastcall

	defc	mul2 = m32_fsmul2_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _mul2
defc _mul2 = m32_fsmul2_fastcall
ENDIF

