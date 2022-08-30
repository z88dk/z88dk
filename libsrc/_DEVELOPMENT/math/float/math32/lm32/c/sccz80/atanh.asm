
	SECTION	code_fp_math32
	PUBLIC	atanh
	EXTERN	_m32_atanhf

	defc	atanh = _m32_atanhf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atanh
defc _atanh = _m32_atanhf
ENDIF

