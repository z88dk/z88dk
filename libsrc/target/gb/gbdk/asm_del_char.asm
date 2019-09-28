        SECTION         code_driver

        PUBLIC          asm_del_char

        GLOBAL          __console_x
        GLOBAL          __console_y
        GLOBAL          asm_scroll
        GLOBAL          asm_setchar
        GLOBAL          asm_del_char

        INCLUDE "target/gb/def/gb_globals.def"

asm_del_char:
        ;; Delete a character
        CALL    rew_curs
	ld	a,(__console_x)
	ld	c,a
	ld	a,(__console_y)
	ld	b,a
        LD      A,' '
        jp	asm_setchar

        ;; Rewind the cursor
rew_curs:
        PUSH    HL
        LD      HL,__console_x  ; X coordinate
        XOR     A
        CP      (HL)
        jr      z,rew_curs_1
        DEC     (HL)
        JR      rew_curs_2
rew_curs_1:
        LD      (HL),MAXCURSPOSX
        LD      HL,__console_y  ; Y coordinate
        XOR     A
        CP      (HL)
        JR      Z,rew_curs_2
        DEC     (HL)
rew_curs_2:
        POP     HL
        RET

