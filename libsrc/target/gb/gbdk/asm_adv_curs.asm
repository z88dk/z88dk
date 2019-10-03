
        SECTION         code_driver

        PUBLIC          asm_adv_curs

	GLOBAL		__mode
        GLOBAL          __console_x
        GLOBAL          __console_y
        GLOBAL          asm_scroll

        INCLUDE "target/gb/def/gb_globals.def"

asm_adv_curs:
        PUSH    HL
        LD      HL,__console_x  ; X coordinate
        LD      A,MAXCURSPOSX
        CP      (HL)
        JR      Z,adv_curs_1
        INC     (HL)
	pop	hl
	ret
adv_curs_1:
        LD      (HL),0x00
        LD      HL,__console_y  ; Y coordinate
        LD      A,MAXCURSPOSY
        CP      (HL)
        JR      Z,adv_curs_2
        INC     (HL)
	pop	hl
	ret
adv_curs_2:
        ;; See if scrolling is disabled
        LD      A,(__mode)
        cp      G_MODE
        ; In a graphics mode, we just reset to (0,0)
        jr      z,reset_coords
consider_text_mode:
        AND     M_NO_SCROLL
        JR      Z,adv_curs_3
        ;; Nope - reset the cursor to (0,0)
reset_coords:
        XOR     A
        LD      (__console_y),A
        LD      (__console_x),A
        pop     hl
        ret
adv_curs_3:
        CALL    asm_scroll
        POP     HL
        RET
