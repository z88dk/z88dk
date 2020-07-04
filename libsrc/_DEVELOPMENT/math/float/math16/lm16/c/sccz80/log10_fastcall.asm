
	SECTION	code_fp_math16
	PUBLIC	log10_fastcall
	EXTERN	_m16_log10f

	defc	log10_fastcall = _m16_log10f

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log10_fastcall
defc _log10_fastcall = _m16_log10f
ENDIF

