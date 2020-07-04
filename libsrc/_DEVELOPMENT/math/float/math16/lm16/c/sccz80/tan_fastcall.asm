
	SECTION	code_fp_math16
	PUBLIC	tan_fastcall
	EXTERN	_m16_tanf

	defc	tan_fastcall = _m16_tanf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tan_fastcall
defc _tan_fastcall = _m16_tanf
ENDIF

