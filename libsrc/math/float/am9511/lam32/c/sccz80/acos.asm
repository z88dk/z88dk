
	SECTION	code_fp_am9511
	PUBLIC	acos
	EXTERN	cam32_sccz80_acos

	defc	acos = cam32_sccz80_acos


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _acos
defc _acos = cam32_sccz80_acos
ENDIF

