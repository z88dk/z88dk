
	SECTION	code_fp_math32
	PUBLIC	log2_fastcall
	EXTERN	_m32_log2f

	defc	log2_fastcall = _m32_log2f

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _log2_fastcall
defc _log2_fastcall = _m32_log2f
ENDIF

