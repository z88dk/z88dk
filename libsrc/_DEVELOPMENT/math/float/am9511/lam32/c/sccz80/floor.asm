
	SECTION	code_fp_am9511
	PUBLIC	floor
	EXTERN	asm_am9511_floor_fastcall

	defc	floor = asm_am9511_floor_fastcall

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _floor
EXTERN cam32_sdcc_floor
defc _floor = cam32_sdcc_floor
ENDIF

