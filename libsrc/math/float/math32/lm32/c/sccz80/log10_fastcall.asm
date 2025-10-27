
	SECTION	code_fp_math32
	PUBLIC	log10_fastcall
	EXTERN	_m32_log10f

	defc	log10_fastcall = _m32_log10f

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log10_fastcall
defc _log10_fastcall = _m32_log10f
ENDIF

