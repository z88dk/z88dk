
	SECTION	code_fp_math32
	PUBLIC	ceil
	EXTERN	_m32_ceilf

	defc	ceil = _m32_ceilf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ceil
defc _ceil = ceil
ENDIF

