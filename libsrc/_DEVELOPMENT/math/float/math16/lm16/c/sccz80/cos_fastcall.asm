
	SECTION	code_fp_math16
	PUBLIC	cos_fastcall
	EXTERN	_m16_cosf

	defc	cos_fastcall = _m16_cosf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _cos_fastcall
defc _cos_fastcall = _m16_cosf
ENDIF

