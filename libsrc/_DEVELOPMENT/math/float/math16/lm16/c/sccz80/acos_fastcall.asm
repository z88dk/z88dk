
	SECTION	code_fp_math16
	PUBLIC	acos_fastcall
	EXTERN	_m16_acosf

	defc	acos_fastcall = _m16_acosf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _acos_fastcall
defc _acos_fastcall = _m16_acosf
ENDIF

