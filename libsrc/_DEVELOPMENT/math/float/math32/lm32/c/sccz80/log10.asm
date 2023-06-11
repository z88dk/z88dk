
	SECTION	code_fp_math32
	PUBLIC	log10
	EXTERN	_m32_log10f

	defc	log10 = _m32_log10f

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log10
defc _log10 = _m32_log10f
ENDIF

