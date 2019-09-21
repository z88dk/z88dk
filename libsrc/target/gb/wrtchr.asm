
	SECTION	code_driver

	PUBLIC	wrtchr
	PUBLIC	_wrtchr

	GLOBAL	__mode
	GLOBAL	asm_wrtchr
	GLOBAL	gmode

	GLOBAL	tx
	GLOBAL	ty

        INCLUDE "target/gb/def/gb_globals.def"
	


; void __LIB__    wrtchr(char chr);
wrtchr:
_wrtchr:                        ; Banked
        PUSH    BC

        LD      A,(__mode)
        CP      G_MODE
        CALL    NZ,gmode

        LD      HL,sp+4
        LD      C,(HL)

        CALL    asm_wrtchr
        CALL    adv_gcurs

        POP     BC
        RET


        ;; Advance the cursor
adv_gcurs:
        PUSH    HL
        LD      HL,tx   ; X coordinate
        LD      A,MAXCURSPOSX
        CP      (HL)
        JR      Z,adv_1
        INC     (HL)
        JR      adv_99
adv_1:
        LD      (HL),0x00
        LD      HL,ty   ; Y coordinate
        LD      A,MAXCURSPOSY
        CP      (HL)
        JR      Z,adv_2
        INC     (HL)
        JR      adv_99
adv_2:
        LD      (HL),0x00
adv_99:
        POP     HL
        RET

