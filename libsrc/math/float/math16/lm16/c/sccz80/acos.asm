
	SECTION	code_fp_math16
	PUBLIC	acosf16
	EXTERN	_m16_acosf

	defc	acosf16 = _m16_acosf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _acosf16
defc _acosf16 = acosf16
ENDIF

