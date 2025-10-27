
	SECTION	code_fp_am9511
	PUBLIC	frexp
	EXTERN	cam32_sccz80_frexp

	defc	frexp = cam32_sccz80_frexp


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _frexp
defc _frexp = frexp
ENDIF

