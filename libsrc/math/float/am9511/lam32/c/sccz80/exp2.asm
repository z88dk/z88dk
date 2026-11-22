
	SECTION	code_fp_am9511
	PUBLIC	exp2
	EXTERN	cam32_sccz80_exp2

	defc	exp2 = cam32_sccz80_exp2


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp2
defc _exp2 = cam32_sccz80_exp2
ENDIF
