
	SECTION	code_fp_math16
	PUBLIC	log10f16
	EXTERN	_m16_log10f

	defc	log10f16 = _m16_log10f


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log10f16
defc _log10f16 = log10f16
ENDIF

