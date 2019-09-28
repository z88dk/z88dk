
	SECTION	code_driver

	PUBLIC	asm_wrtchr

	GLOBAL	y_table
	GLOBAL	__console_x
	GLOBAL	__console_y
	GLOBAL	__fgcolour
	GLOBAL	__bgcolour

        INCLUDE "target/gb/def/gb_globals.def"

        ;; Write character C
; Entry: C = character
;       hl = font start
asm_wrtchr:
	push	hl		;save font
        LD      HL,y_table
        LD      D,0x00
        LD      A,(__console_y)
        RLCA
        RLCA
        RLCA
        LD      E,A
        ADD     HL,DE
        ADD     HL,DE
        LD      B,(HL)
        INC     HL
        LD      H,(HL)
        LD      L,B

        LD      A,(__console_x)
        RLCA
        RLCA
        RLCA
        LD      E,A
        ADD     HL,DE
        ADD     HL,DE

        LD      A,C
        LD      B,H
        LD      C,L

        LD      H,D
        LD      L,A
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
	pop	de		;font back
        ADD     HL,DE

        LD      D,H
        LD      E,L
        LD      H,B
        LD      L,C

        if      0
        LD      A,(mod_col)
        LD      C,A
        else
        LD      A,(__fgcolour)
        LD      C,A
        endif
chrloop:
        LD      A,(DE)
        INC     DE
        PUSH    DE

        if      1
        PUSH    HL
        LD      HL,__bgcolour
        LD      L,(HL)
        endif

        LD      B,A
        XOR     A
        if      0
        BIT     0,C
        else
        BIT     0,L
        endif
        JR      Z,a0
        CPL
a0:     OR      B
        if      0
        BIT     2,C
        else
        BIT     0,C
        endif
        JR      NZ,a1
        XOR     B
a1:     LD      D,A
        XOR     A
        if      0
        BIT     1,C
        else
        BIT     1,L
        endif
        JR      Z,b0
        CPL
b0:     OR      B
        if      0
        BIT     3,C
        else
        BIT     1,C
        endif
        JR      NZ,b1
        XOR     B
b1:
        LD      E,A
        if      1
        POP     HL
        endif
chrwait:
        LDH     A,(STAT)
        BIT     1,A
        JR      NZ,chrwait

        LD      A,D
        LD      (HL+),A
        LD      A,E
        LD      (HL+),A
        POP     DE
        LD      A,L
        AND     0x0F
        JR      NZ,chrloop
	ret

