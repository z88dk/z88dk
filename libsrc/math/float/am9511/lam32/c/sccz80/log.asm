
	SECTION	code_fp_am9511
	PUBLIC	log
	EXTERN	cam32_sccz80_log

	defc	log = cam32_sccz80_log


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log
defc _log = cam32_sccz80_log
ENDIF

