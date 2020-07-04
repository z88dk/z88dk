
	SECTION	code_fp_math16
	PUBLIC	sin_fastcall
	EXTERN	_m16_sinf

	defc	sin_fastcall = _m16_sinf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sin_fastcall
defc _sin_fastcall = _m16_sinf
ENDIF

