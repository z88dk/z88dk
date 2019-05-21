
	SECTION	code_fp_math32
	PUBLIC	sin
	EXTERN	cm32_sccz80_sin

	defc	sin = cm32_sccz80_sin


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sin
defc _sin = sin
ENDIF

