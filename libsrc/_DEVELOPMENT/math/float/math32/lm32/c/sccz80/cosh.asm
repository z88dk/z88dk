
	SECTION	code_fp_math32
	PUBLIC	cosh
	EXTERN	cm32_sccz80_cosh

	defc	cosh = cm32_sccz80_cosh


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _cosh
defc _cosh = cosh
ENDIF

