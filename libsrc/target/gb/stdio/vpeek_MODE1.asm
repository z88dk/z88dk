
        SECTION	code_driver

        PUBLIC	vpeek_MODE1
        PUBLIC  vpeek_read_screen

        GLOBAL	y_table
        GLOBAL  vpeek_screendollar
        GLOBAL  generic_console_font32

        INCLUDE "target/gb/def/gb_globals.def"


;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
vpeek_MODE1:
        ld      hl,sp + -8
        ld      sp,hl
        push    hl              ;Save buffer
        call    vpeek_read_screen
        jp      vpeek_screendollar        



vpeek_read_screen:
        push    hl
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
        ret

        

