
	SECTION	code_fp_math32
	PUBLIC	floor
	EXTERN	m32_floor_fastcall

	defc	floor = m32_floor_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _floor
EXTERN cm32_sdcc_floor
defc _floor = cm32_sdcc_floor
ENDIF

