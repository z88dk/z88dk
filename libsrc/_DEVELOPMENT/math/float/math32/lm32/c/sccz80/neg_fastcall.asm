
	SECTION	code_fp_math32
	PUBLIC	neg_fastcall
	EXTERN	m32_fsneg

	defc	neg_fastcall = m32_fsneg

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _neg_fastcall
defc _neg_fastcall = m32_fsneg
ENDIF

