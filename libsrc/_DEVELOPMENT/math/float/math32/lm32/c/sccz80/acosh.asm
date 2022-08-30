
	SECTION	code_fp_math32
	PUBLIC	acosh
	EXTERN	_m32_acoshf

	defc	acosh = _m32_acoshf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _acosh
defc _acosh = _m32_acoshf
ENDIF

