
	SECTION	code_fp_math32
	PUBLIC	sin
	EXTERN	_m32_sinf

	defc	sin = _m32_sinf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sin
defc _sin = _m32_sinf
ENDIF

