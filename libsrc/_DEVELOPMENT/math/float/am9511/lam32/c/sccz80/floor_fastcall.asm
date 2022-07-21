
	SECTION	code_fp_am9511
	PUBLIC	floor_fastcall
	EXTERN	asm_am9511_floor_fastcall

	defc	floor_fastcall = asm_am9511_floor_fastcall


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _floor_fastcall
defc _floor_fastcall = asm_am9511_floor_fastcall
ENDIF

