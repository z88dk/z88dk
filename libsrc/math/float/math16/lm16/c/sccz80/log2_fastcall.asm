
	SECTION	code_fp_math16
	PUBLIC	log2f16_fastcall
	EXTERN	_m16_log2f

	defc	log2f16_fastcall = _m16_log2f


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log2f16_fastcall
defc _log2f16_fastcall = _m16_log2f
ENDIF

