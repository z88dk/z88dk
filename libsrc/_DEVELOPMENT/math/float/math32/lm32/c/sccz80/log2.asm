
	SECTION	code_fp_math32
	PUBLIC	log2
	EXTERN	_m32_log2f

	defc	log2 = _m32_log2f

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log2
defc _log2 = _m32_log2f
ENDIF

