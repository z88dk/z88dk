
	SECTION	code_fp_math16
	PUBLIC	acosf16_fastcall
	EXTERN	_m16_acosf

	defc	acosf16_fastcall = _m16_acosf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _acosf16_fastcall
defc _acosf16_fastcall = _m16_acosf
ENDIF

