
	SECTION	code_fp_math32
	PUBLIC	sinh
	EXTERN	_m32_sinhf

	defc	sinh = _m32_sinhf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sinh
EXTERN cm32_sdcc_sinh
defc _sinh = cm32_sdcc_sinh
ENDIF

