
	SECTION	code_fp_math32
	PUBLIC	tan
	EXTERN	cm32_sccz80_tan

	defc	tan = cm32_sccz80_tan


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tan
defc _tan = tan
ENDIF

