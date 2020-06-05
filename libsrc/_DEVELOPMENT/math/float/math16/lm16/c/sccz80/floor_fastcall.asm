
	SECTION	code_fp_math16
	PUBLIC	m16_floor_fastcall
	EXTERN	asm_f16_floor

	defc	m16_floor_fastcall = asm_f16_floor


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _m16_floor_fastcall
defc _m16_floor_fastcall = asm_f16_floor
ENDIF

