
	SECTION		code_driver

	PUBLIC		asm_putchar

	GLOBAL		__mode
	GLOBAL		__console_x
	GLOBAL		__console_y
	GLOBAL		asm_scroll
	GLOBAL		asm_cls
	GLOBAL		asm_del_char
	GLOBAL		asm_adv_curs
	GLOBAL		asm_setchar

        INCLUDE "target/gb/def/gb_globals.def"

asm_putchar:

        push    af
        ld      a,(__mode)
        and     M_NO_INTERP
        jr      nz,asm_putchar_2
        pop     af
        cp      10
        jr      nz,check_BS
        call    cr_curs
        ret
check_BS:
        cp      8
        jr      nz,check_CLS
        call    asm_del_char
        ret
check_CLS:
	cp	12
	jr	nz,asm_putchar_1
	call	asm_cls
	ret
asm_putchar_2:
        pop     af
asm_putchar_1:
	ld	hl,__console_x
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
        CALL    asm_setchar
        CALL    asm_adv_curs
        RET

cr_curs:
        PUSH    HL
        XOR     A
        LD      (__console_x),A
        LD      HL,__console_y  ; Y coordinate
        LD      A,MAXCURSPOSY
        CP      (HL)
        JR      Z,cr_curs_1
        INC     (HL)
        JR      cr_curs_2
cr_curs_1:
        CALL    asm_scroll
cr_curs_2:
        POP     HL
        RET
