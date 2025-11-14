
	SECTION	code_fp_am9511
	PUBLIC	log10
	EXTERN	cam32_sccz80_log10

	defc	log10 = cam32_sccz80_log10


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log10
defc _log10 = cam32_sccz80_log10
ENDIF

