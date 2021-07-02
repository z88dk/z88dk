
	SECTION	code_fp_math32
	PUBLIC	neg
	EXTERN	cm32_sccz80_fsneg

	defc	neg = cm32_sccz80_fsneg

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _neg
EXTERN cm32_sdcc_fsneg
defc _neg = cm32_sdcc_fsneg
ENDIF

