
	SECTION	code_fp_math16
	PUBLIC	log10
	EXTERN	_m16_log10f

	defc	log10 = _m16_log10f

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log10
EXTERN cm16_sdcc_log10
defc _log10 = cm16_sdcc_log10
ENDIF

