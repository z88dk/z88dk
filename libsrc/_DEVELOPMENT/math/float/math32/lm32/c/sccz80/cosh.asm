
	SECTION	code_fp_math32
	PUBLIC	cosh
	EXTERN	_m32_coshf

	defc	cosh = _m32_coshf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _cosh
defc _cosh = _m32_coshf
ENDIF

