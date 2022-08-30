
	SECTION	code_fp_math32
	PUBLIC	neg
	EXTERN	m32_fsneg

	defc	neg = m32_fsneg

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _neg
defc _neg = m32_fsneg
ENDIF

