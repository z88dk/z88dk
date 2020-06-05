
	SECTION	code_fp_math16
	PUBLIC	floor_fastcall
	EXTERN	asm_f16_floor

	defc	floor_fastcall = asm_f16_floor


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _floor_fastcall
defc _floor_fastcall = asm_f16_floor
ENDIF

