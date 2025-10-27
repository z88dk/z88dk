
	SECTION	code_fp_math32
	PUBLIC	floor_fastcall
	EXTERN	m32_floor_fastcall

	defc	floor_fastcall = m32_floor_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _floor_fastcall
defc _floor_fastcall = m32_floor_fastcall
ENDIF

