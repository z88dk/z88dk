
	SECTION	code_fp_math32
	PUBLIC	sinh
	EXTERN	_m32_sinhf

	defc	sinh = _m32_sinhf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sinh
defc _sinh = _m32_sinhf
ENDIF

