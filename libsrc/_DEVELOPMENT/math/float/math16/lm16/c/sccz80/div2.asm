
	SECTION	code_fp_math16
	PUBLIC	div2
	EXTERN	cm16_sccz80_div2

	defc	div2 = cm16_sccz80_div2


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _div2
EXTERN	cm16_sdcc_div2
defc _div2 = cm16_sdcc_div2
ENDIF

