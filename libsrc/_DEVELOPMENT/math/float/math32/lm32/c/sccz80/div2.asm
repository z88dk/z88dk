
	SECTION	code_fp_math32
	PUBLIC	div2
	EXTERN	m32_fsdiv2_fastcall

	defc	div2 = m32_fsdiv2_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _div2
defc _div2 = m32_fsdiv2_fastcall
ENDIF

