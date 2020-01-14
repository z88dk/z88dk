
	SECTION	code_fp_math32
	PUBLIC	frexp
	EXTERN	cm32_sccz80_frexp

	defc	frexp = cm32_sccz80_frexp


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _frexp
EXTERN cm32_sdcc_frexp
defc _frexp = cm32_sdcc_frexp
ENDIF

