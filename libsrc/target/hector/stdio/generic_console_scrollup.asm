

    MODULE  generic_console_scrollup

    SECTION code_clib
    PUBLIC  generic_console_scrollup
    
    INCLUDE "target/hector/def/hector1.def"


; Note, due to memory constraints this doesn't handle varying of the font height
generic_console_scrollup:
    push    bc
    push    de
    ld      hl,HEC_SCREEN+(HEC_STRIDE*8)
    ld      de,HEC_SCREEN
    ld      bc,+(HEC_STRIDE * (HEC_MAXY-8-1))
    ldir
    ld      d,h
    ld      e,l
    inc     de
    xor     a
    ld      bc,HEC_STRIDE*8 - 1
    ldir
    pop     de
    pop     bc
    ret
