
	SECTION	code_fp_math32
	PUBLIC	fabs
	EXTERN	m32_fabs

	defc	fabs = m32_fabs

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _fabs
defc _fabs = fabs
ENDIF

