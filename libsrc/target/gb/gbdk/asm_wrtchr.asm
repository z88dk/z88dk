
    SECTION code_driver

    PUBLIC  asm_wrtchr

    GLOBAL  y_table
    GLOBAL  __fgcolour
    GLOBAL  __bgcolour
    EXTERN generic_console_flags

    INCLUDE "target/gb/def/gb_globals.def"

        ;; Write character C
; Entry: a = character
;        c = x
;        b = y
;       hl = font start
asm_wrtchr:
        push	hl      ;save font
        push    af      ;save character
        LD      HL,y_table
        LD      D,0x00
        LD      A,b
        RLCA
        RLCA
        RLCA
        LD      E,A
        ADD     HL,DE
        ADD     HL,DE
        LD      A,(HL+)
        LD      H,(HL)
        LD      L,A

        LD      A,c
        RLCA
        RLCA
        RLCA
        LD      E,A
        ADD     HL,DE
        ADD     HL,DE

        pop     af      ; Get character back
        LD      B,H	; bc=tile address
        LD      C,L

        LD      H,D	;d=0x00
        LD      L,A
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        pop     de      ;font back
        ADD     HL,DE

        LD      D,H	;de=font
        LD      E,L
        LD      H,B	;hl=tile address
        LD      L,C

        LD      A,(__fgcolour)
        LD      C,A
chrloop:
        LD      A,(DE)
        INC     DE
        PUSH    DE	;save font
	; Support generic console additional flags
        ld      d,a
        ld      a,(generic_console_flags)
        ld      e,a
        ld      a,d
        bit     4,e
        jr      z,not_bold
        rrca
        or      d
not_bold:
        bit     7,e
        jr      z,not_inv
        cpl
not_inv:
        ld      d,a
        bit     3,e
        jr      z,not_underline
        ld      a,l
        and     15
        cp      14
        jr      nz,not_underline
        ld      d,255
not_underline:
        ld      a,d
        PUSH    HL	;save screen address
        LD      HL,__bgcolour
        LD      L,(HL)

	; c = fgcolour
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
        POP     HL	;screen address back
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

