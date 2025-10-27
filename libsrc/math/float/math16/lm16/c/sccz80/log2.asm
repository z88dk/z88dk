
	SECTION	code_fp_math16
	PUBLIC	log2f16
	EXTERN	_m16_log2f

	defc	log2f16 = _m16_log2f


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log2f16
defc _log2f16 = log2f16
ENDIF

