
	SECTION	code_fp_math32
	PUBLIC	acosh
	EXTERN	_m32_acoshf

	defc	acosh = _m32_acoshf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _acosh
EXTERN cm32_sdcc_acosh
defc _acosh = cm32_sdcc_acosh
ENDIF

