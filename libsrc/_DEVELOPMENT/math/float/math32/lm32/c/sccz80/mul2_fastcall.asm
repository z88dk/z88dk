
	SECTION	code_fp_math32
	PUBLIC	mul2_fastcall
	EXTERN	_m32_mul2f

	defc	mul2_fastcall = _m32_mul2f

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _mul2_fastcall
defc _mul2_fastcall = mul2_fastcall
ENDIF

