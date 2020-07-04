
	SECTION	code_fp_math16
	PUBLIC	log
	EXTERN	_m16_logf

	defc	log = _m16_logf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log
EXTERN cm16_sdcc_log
defc _log = cm16_sdcc_log
ENDIF

