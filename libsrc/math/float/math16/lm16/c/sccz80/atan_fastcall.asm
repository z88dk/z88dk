
	SECTION	code_fp_math16
	PUBLIC	atanf16_fastcall
	EXTERN	_m16_atanf

	defc	atanf16_fastcall = _m16_atanf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atanf16_fastcall
defc _atanf16_fastcall = _m16_atanf
ENDIF

