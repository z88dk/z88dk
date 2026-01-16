
	SECTION	code_fp_math32
	PUBLIC	fabs_fastcall
	EXTERN	m32_fabs_fastcall

	defc	fabs_fastcall = m32_fabs_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _fabs_fastcall
defc _fabs_fastcall = m32_fabs_fastcall
ENDIF

