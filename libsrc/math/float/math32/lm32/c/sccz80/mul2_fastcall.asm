
	SECTION	code_fp_math32
	PUBLIC	mul2_fastcall
	EXTERN	m32_fsmul2_fastcall

	defc	mul2_fastcall = m32_fsmul2_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _mul2_fastcall
defc _mul2_fastcall = m32_fsmul2_fastcall
ENDIF

