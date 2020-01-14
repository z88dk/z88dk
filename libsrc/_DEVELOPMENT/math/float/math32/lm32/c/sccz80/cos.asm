
	SECTION	code_fp_math32
	PUBLIC	cos
	EXTERN	_m32_cosf

	defc	cos = _m32_cosf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _cos
EXTERN cm32_sdcc_cos
defc _cos = cm32_sdcc_cos
ENDIF

