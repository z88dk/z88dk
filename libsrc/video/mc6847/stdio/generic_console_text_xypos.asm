


    SECTION code_clib

    PUBLIC  generic_console_text_xypos

    INCLUDE "video/mc6847/mc6847.inc"


generic_console_text_xypos:
    push    af
    ld      l, b
    ld      h, 0
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, hl      ;*32
    IF FORpc6001
        ld      a,(SYSVAR_screen-1)
        inc     a
        inc     a
    ELSE
        ld      a,+(DISPLAY / 256)
    ENDIF
    ld      b, a
    add     hl, bc
    pop     af
    ret