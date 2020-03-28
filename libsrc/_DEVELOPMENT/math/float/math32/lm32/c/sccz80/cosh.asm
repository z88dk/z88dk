
	SECTION	code_fp_math32
	PUBLIC	cosh
	EXTERN	_m32_coshf

	defc	cosh = _m32_coshf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _cosh
EXTERN cm32_sdcc_cosh
defc _cosh = cm32_sdcc_cosh
ENDIF

