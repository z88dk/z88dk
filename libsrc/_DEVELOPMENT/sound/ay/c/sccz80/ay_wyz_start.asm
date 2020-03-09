
	SECTION	code_psg

	PUBLIC	ay_wyz_start

	EXTERN	asm_wyz_start


ay_wyz_start:
	ld	a,l
	jp	asm_wyz_start

	
; SDCC bridge for Classic
IF __CLASSIC
PUBLIC  _ay_wyz_start
defc _ay_wyz_start = ay_wyz_start
ENDIF
