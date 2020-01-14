
	SECTION	code_fp_math32
	PUBLIC	tan_fastcall
	EXTERN	_m32_tanf

	defc	tan_fastcall = _m32_tanf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tan_fastcall
defc _tan_fastcall = _m32_tanf
ENDIF

