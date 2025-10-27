
	SECTION	code_fp_am9511
	PUBLIC	exp
	EXTERN	cam32_sccz80_exp

	defc	exp = cam32_sccz80_exp


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _exp
defc _exp = cam32_sccz80_exp
ENDIF

