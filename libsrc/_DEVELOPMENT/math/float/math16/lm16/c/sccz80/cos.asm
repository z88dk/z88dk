
	SECTION	code_fp_math16
	PUBLIC	cos
	EXTERN	_m16_cosf

	defc	cos = _m16_cosf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _cos
EXTERN cm16_sdcc_cos
defc _cos = cm16_sdcc_cos
ENDIF

