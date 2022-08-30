
	SECTION	code_fp_math32
	PUBLIC	tan
	EXTERN	_m32_tanf

	defc	tan = _m32_tanf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tan
EXTERN cm32_sdcc_tan
defc _tan = _m32_tanf
ENDIF

