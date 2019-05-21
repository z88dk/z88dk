
	SECTION	code_fp_math32
	PUBLIC	acos
	EXTERN	cm32_sccz80_acos

	defc	acos = cm32_sccz80_acos


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _acos
defc _acos = acos
ENDIF

