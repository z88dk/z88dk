
	SECTION	code_fp_am9511
	PUBLIC	div2
	EXTERN	cam32_sccz80_div2

	defc	div2 = cam32_sccz80_div2

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _div2
EXTERN	cam32_sdcc_dcc_div2
defc _div2 = cam32_sdcc_dcc_div2
ENDIF

