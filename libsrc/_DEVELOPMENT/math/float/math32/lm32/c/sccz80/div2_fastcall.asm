
	SECTION	code_fp_math32
	PUBLIC	div2_fastcall
	EXTERN	_m32_div2f

	defc	div2_fastcall = _m32_div2f

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _div2_fastcall
defc _div2_fastcall = div2_fastcall
ENDIF

