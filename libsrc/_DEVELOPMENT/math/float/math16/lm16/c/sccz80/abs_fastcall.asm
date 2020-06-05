
	SECTION	code_fp_math32
	PUBLIC	fabs
	EXTERN	m32_fabs_fastcall

	defc	fabs = m32_fabs_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _fabs
EXTERN cm32_sdcc_fabs
defc _fabs = cm32_sdcc_fabs
ENDIF

