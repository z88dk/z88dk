
	SECTION	code_fp_math32
	PUBLIC	ldexp
	EXTERN	cm32_sccz80_ldexp

	defc	ldexp = cm32_sccz80_ldexp

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ldexp
EXTERN cm32_sdcc_ldexp
defc _ldexp = cm32_sdcc_ldexp
ENDIF

