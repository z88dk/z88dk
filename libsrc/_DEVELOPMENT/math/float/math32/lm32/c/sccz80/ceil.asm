
	SECTION	code_fp_math32
	PUBLIC	ceil
	EXTERN	m32_ceil_fastcall

	defc	ceil = m32_ceil_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ceil
defc _ceil = m32_ceil_fastcall
ENDIF

