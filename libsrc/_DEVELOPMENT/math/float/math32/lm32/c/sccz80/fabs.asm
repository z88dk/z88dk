
	SECTION	code_fp_math32
	PUBLIC	fabs
	EXTERN	cm32_sccz80_fabs

	defc	fabs = cm32_sccz80_fabs

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _fabs
defc _fabs = fabs
ENDIF

