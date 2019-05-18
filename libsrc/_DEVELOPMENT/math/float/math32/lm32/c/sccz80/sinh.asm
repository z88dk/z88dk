
	SECTION	code_fp_math32
	PUBLIC	sinh
	EXTERN	cm32_sccz80_sinh

	defc	sinh = cm32_sccz80_sinh


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sinh
defc _sinh = sinh
ENDIF

