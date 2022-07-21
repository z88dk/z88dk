
	SECTION	code_fp_math32
	PUBLIC	asinh
	EXTERN	_m32_asinhf

	defc	asinh = _m32_asinhf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _asinh
defc _asinh = _m32_asinhf
ENDIF

