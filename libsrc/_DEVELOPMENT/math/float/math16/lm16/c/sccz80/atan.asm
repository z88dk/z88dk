
	SECTION	code_fp_math16
	PUBLIC	atanf16
	EXTERN	_m16_atanf

	defc	atanf16 = _m16_atanf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atanf16
EXTERN cm16_sdcc_atan
defc _atanf16 = cm16_sdcc_atan
ENDIF

