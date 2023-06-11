
	SECTION	code_fp_math32
	PUBLIC	floor
	EXTERN	m32_floor_fastcall

	defc	floor = m32_floor_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _floor
defc _floor = m32_floor_fastcall
ENDIF

