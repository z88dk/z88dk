
	SECTION	code_fp_am9511
	PUBLIC	neg
	EXTERN	cam32_sccz80_neg

	defc	neg = cam32_sccz80_neg


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _neg
defc _neg = cam32_sccz80_neg
ENDIF

