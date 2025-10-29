
	SECTION	code_fp_math16
	PUBLIC	sinf16_fastcall
	EXTERN	_m16_sinf

	defc	sinf16_fastcall = _m16_sinf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sinf16_fastcall
defc _sinf16_fastcall = _m16_sinf
ENDIF

