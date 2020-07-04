
	SECTION	code_fp_math16
	PUBLIC	sin
	EXTERN	_m16_sinf

	defc	sin = _m16_sinf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sin
EXTERN cm16_sdcc_sin
defc _sin = cm16_sdcc_sin
ENDIF

