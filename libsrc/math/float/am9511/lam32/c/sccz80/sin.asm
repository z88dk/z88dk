
	SECTION	code_fp_am9511
	PUBLIC	sin
	EXTERN	cam32_sccz80_sin

	defc	sin = cam32_sccz80_sin


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sin
defc _sin = cam32_sccz80_sin
ENDIF

