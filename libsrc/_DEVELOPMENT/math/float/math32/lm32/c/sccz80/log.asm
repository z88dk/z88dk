
	SECTION	code_fp_math32
	PUBLIC	log
	EXTERN	_m32_logf

	defc	log = _m32_logf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log
EXTERN cm32_sdcc_log
defc _log = cm32_sdcc_log
ENDIF

