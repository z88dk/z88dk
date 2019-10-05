
        SECTION	code_driver

        PUBLIC	asm_vpeek_graphics

        GLOBAL	y_table
        GLOBAL  vpeek_screendollar

        INCLUDE "target/gb/def/gb_globals.def"

;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
asm_vpeek_graphics:
        ld      hl,sp + -8
        ld      sp,hl
        push    hl              ;Save buffer

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

        ;hl = screen location
        pop     de
        push    de

        ld      b,8
wait_1:
        LDH     A,(STAT)
        BIT     1,A
        JR      NZ,wait_1
        ld      a,(hl+)         ;Basically we'll fail if background isn't colour 0
        or      (hl)  
        inc     hl
        ld      (de),a
        inc     de
        djnz    wait_1
        jp      vpeek_screendollar


