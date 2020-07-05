
	SECTION	code_fp_math16
	PUBLIC	cosf16
	EXTERN	_m16_cosf

	defc	cosf16 = _m16_cosf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _cosf16
EXTERN cm16_sdcc_cos
defc _cosf16 = cm16_sdcc_cos
ENDIF

