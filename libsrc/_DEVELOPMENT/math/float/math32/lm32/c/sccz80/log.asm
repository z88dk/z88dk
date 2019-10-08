
	SECTION	code_fp_math32
	PUBLIC	log
	EXTERN	cm32_sccz80_log

	defc	log = cm32_sccz80_log

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log
defc _log = log
ENDIF

