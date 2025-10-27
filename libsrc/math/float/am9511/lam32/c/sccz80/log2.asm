
	SECTION	code_fp_am9511
	PUBLIC	log2
	EXTERN	cam32_sccz80_log2

	defc	log2 = cam32_sccz80_log2


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log2
defc _log2 = cam32_sccz80_log2
ENDIF

