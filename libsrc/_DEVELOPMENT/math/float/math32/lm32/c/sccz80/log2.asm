
	SECTION	code_fp_math32
	PUBLIC	log2
	EXTERN	cm32_sccz80_log2

	defc	log2 = cm32_sccz80_log2

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log2
defc _log2 = log2
ENDIF

