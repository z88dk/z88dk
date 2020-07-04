
	SECTION	code_fp_math16
	PUBLIC	atan
	EXTERN	_m16_atanf

	defc	atan = _m16_atanf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atan
EXTERN cm16_sdcc_atan
defc _atan = cm16_sdcc_atan
ENDIF

