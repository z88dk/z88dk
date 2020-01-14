
	SECTION	code_fp_math32
	PUBLIC	ceil_fastcall
	EXTERN	m32_ceil_fastcall

	defc	ceil_fastcall = m32_ceil_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ceil_fastcall
defc _ceil_fastcall = m32_ceil_fastcall
ENDIF

