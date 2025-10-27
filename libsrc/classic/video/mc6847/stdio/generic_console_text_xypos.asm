


    SECTION code_driver

    PUBLIC  generic_console_text_xypos

    INCLUDE "classic/video/mc6847/mc6847.inc"


generic_console_text_xypos:
    ld      l, b
    ld      h, 0
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, hl      ;*32
    IF FORpc6001
        ld      a,(SYSVAR_screen)
        inc     a
        inc     a
        ld      b,a
    ELSE
        ld      b,+(DISPLAY / 256)
    ENDIF
    add     hl, bc
    ret