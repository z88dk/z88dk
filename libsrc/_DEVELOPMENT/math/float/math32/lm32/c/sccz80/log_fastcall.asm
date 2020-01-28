
	SECTION	code_fp_math32
	PUBLIC	log_fastcall
	EXTERN	_m32_logf

	defc	log_fastcall = _m32_logf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log_fastcall
defc _log_fastcall = _m32_logf
ENDIF

