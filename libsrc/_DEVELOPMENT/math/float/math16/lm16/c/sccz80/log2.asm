
	SECTION	code_fp_math16
	PUBLIC	log2
	EXTERN	_m16_log2f

	defc	log2 = _m16_log2f

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log2
EXTERN cm16_sdcc_log2
defc _log2 = cm16_sdcc_log2
ENDIF

