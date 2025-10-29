
	SECTION	code_fp_math32
	PUBLIC	div2_fastcall
	EXTERN	m32_fsdiv2_fastcall

	defc	div2_fastcall = m32_fsdiv2_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _div2_fastcall
defc _div2_fastcall = m32_fsdiv2_fastcall
ENDIF

