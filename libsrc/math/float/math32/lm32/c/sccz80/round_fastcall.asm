
	SECTION	code_fp_math32
	PUBLIC	round_fastcall
	EXTERN	_m32_roundf

	defc	round_fastcall = _m32_roundf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _round_fastcall
defc _round_fastcall = _m32_roundf
ENDIF

