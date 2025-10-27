
	SECTION	code_fp_math16
	PUBLIC	log10f16_fastcall
	EXTERN	_m16_log10f

	defc	log10f16_fastcall = _m16_log10f


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log10f16_fastcall
defc _log10f16_fastcall = _m16_log10f
ENDIF

