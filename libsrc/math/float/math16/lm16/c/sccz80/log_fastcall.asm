
	SECTION	code_fp_math32
	PUBLIC	logf16_fastcall
	EXTERN	_m32_logf

	defc	logf16_fastcall = _m32_logf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _logf16_fastcall
defc _logf16_fastcall = _m32_logf
ENDIF

