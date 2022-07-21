
	SECTION	code_fp_am9511
	PUBLIC	tan
	EXTERN	cam32_sccz80_tan

	defc	tan = cam32_sccz80_tan


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tan
defc _tan = cam32_sccz80_tan
ENDIF

