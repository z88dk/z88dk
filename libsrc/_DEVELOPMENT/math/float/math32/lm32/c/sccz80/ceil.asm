
	SECTION	code_fp_math32
	PUBLIC	ceil
	EXTERN	_m32_ceil

	defc	ceil = _m32_ceil

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ceil
defc _ceil = ceil
ENDIF

