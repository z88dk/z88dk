
	SECTION	code_fp_math16
	PUBLIC	acos
	EXTERN	_m16_acosf

	defc	acos = _m16_acosf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _acos
EXTERN cm16_sdcc_acos
defc _acos = cm16_sdcc_acos
ENDIF

