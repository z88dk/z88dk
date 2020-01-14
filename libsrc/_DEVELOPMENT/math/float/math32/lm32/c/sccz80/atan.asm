
	SECTION	code_fp_math32
	PUBLIC	atan
	EXTERN	_m32_atanf

	defc	atan = _m32_atanf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atan
EXTERN cm32_sdcc_atan
defc _atan = cm32_sdcc_atan
ENDIF

