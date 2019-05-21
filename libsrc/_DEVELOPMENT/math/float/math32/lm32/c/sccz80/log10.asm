
	SECTION	code_fp_math32
	PUBLIC	log10
	EXTERN	cm32_sccz80_log10

	defc	log10 = cm32_sccz80_log10


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log10
defc _log10 = log10
ENDIF

