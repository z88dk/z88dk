
	SECTION	code_fp_math32
	PUBLIC	log
	EXTERN	_m32_logf

	defc	log = _m32_logf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log
defc _log = _m32_logf
ENDIF

