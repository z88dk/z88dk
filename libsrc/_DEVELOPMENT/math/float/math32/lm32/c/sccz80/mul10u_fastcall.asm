
	SECTION	code_fp_math32
	PUBLIC	mul10u_fastcall
	EXTERN	_m32_mul10uf

	defc	mul10u_fastcall = _m32_mul10uf

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _mul10u_fastcall
defc _mul10u_fastcall = mul10u_fastcall
ENDIF

