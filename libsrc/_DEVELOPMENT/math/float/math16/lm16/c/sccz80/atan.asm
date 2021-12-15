
	SECTION	code_fp_math16
	PUBLIC	atanf16
	EXTERN	_m16_atanf

	defc	atanf16 = _m16_atanf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atanf16
defc _atanf16 = atanf16
ENDIF

