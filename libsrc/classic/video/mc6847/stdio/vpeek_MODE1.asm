    INCLUDE "classic/video/mc6847/mc6847.inc"


IFNDEF MC6847_IOSPACE

    SECTION code_driver

    PUBLIC  vpeek_MODE1
    EXTERN  vpeek_screendollar
    EXTERN  __mc6847_mode
    EXTERN  __console_font_h 
    EXTERN  generic_console_gfx_xypos_MODE1


;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
vpeek_MODE1:
    ld      hl, -8
    add     hl, sp
    ld      sp, hl
    push    hl                          ;Save buffer
    ex      de, hl                      ;get it into de
    call    generic_console_gfx_xypos_MODE1

    ld      a, (__console_font_h)
    ld      b, a
vpeek_1:
IF FORmc1000
    ld      a, (__mc6847_mode)
    res     0, a
    out     ($80), a
    ld      c, (hl)
    set     0, a
    out     ($80), a
    ex      de, hl
    ld      (hl), c
    inc     hl
    ex      de, hl
ELSE
    ld      a, (hl)
    ld      (de), a
    inc     de
ENDIF
    ld      a, l
    add     32
    ld      l, a
    jr      nc, no_overflow
    inc     h
no_overflow:
    djnz    vpeek_1
    jp      vpeek_screendollar
ENDIF