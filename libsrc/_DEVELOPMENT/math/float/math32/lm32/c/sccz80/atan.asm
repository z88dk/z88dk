
	SECTION	code_fp_math32
	PUBLIC	atan
	EXTERN	cm32_sccz80_atan

	defc	atan = cm32_sccz80_atan


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atan
defc _atan = atan
ENDIF

