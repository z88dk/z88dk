
	SECTION	code_fp_math16
	PUBLIC	sinf16
	EXTERN	_m16_sinf

	defc	sinf16 = _m16_sinf


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sinf16
defc _sinf16 = sinf16
ENDIF

