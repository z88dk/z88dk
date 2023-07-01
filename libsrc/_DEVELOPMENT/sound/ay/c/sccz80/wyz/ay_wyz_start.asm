
    SECTION code_sound_ay

    PUBLIC  ay_wyz_start
    PUBLIC  ay_wyz_start_fastcall

    EXTERN  asm_wyz_start

ay_wyz_start:
    pop     bc
    pop     hl
    push    hl
    push    bc

ay_wyz_start_fastcall:
	push	ix
	push	iy
	ld      a,l
	call    asm_wyz_start
	pop     iy
	pop     ix
	ret


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC  _ay_wyz_start
defc _ay_wyz_start = ay_wyz_start

PUBLIC  _ay_wyz_start_fastcall
defc _ay_wyz_start_fastcall = ay_wyz_start_fastcall
ENDIF
