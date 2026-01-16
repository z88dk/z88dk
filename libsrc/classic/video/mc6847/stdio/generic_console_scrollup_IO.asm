    INCLUDE "classic/video/mc6847/mc6847.inc"

IFDEF MC6847_IOSPACE

    SECTION code_driver
    PUBLIC  generic_console_scrollup

    EXTERN  __mc6847_mode
    EXTERN  __spc1000_attr
    EXTERN  __tms9918_cls
    EXTERN  __tms9918_scrollup


generic_console_scrollup:
IF FORspc1000
    ld      a, (__mc6847_mode)
    cp      10
    jp      z, __tms9918_scrollup
ENDIF
    push    de
    push    bc
    and     a
    jr      nz,scrollup_hires
scrollup_text:
    ld      bc, MC6847_CONSOLE_COLUMNS         ;source
    ld      hl, +((MC6847_CONSOLE_ROWS-1)*MC6847_CONSOLE_COLUMNS)
scroll_loop:
    push    hl
    in      e, (c)
IF FORspc1000
    set     3, b
    in      d, (c)
    res     3, b
ENDIF
    ld      hl, -MC6847_CONSOLE_COLUMNS
    add     hl, bc
    ld      c, l
    ld      b, h
    out     (c), e
IF FORspc1000
    set     3, b
    out     (c), d
    res     3, b
ENDIF
    ld      hl, MC6847_CONSOLE_COLUMNS+1
    add     hl, bc
    ld      c, l
    ld      b, h
    pop     hl
    dec     hl
    ld      a, h
    or      l
    jr      nz, scroll_loop

    ld      hl, -MC6847_CONSOLE_COLUMNS
    add     hl, bc
    ld      c, l
    ld      b, h
    ld      e, 32
    ld      d, ' '
    ld      a, (__spc1000_attr)
scroll_loop_2:
    out     (c), d
IF FORspc1000
    set     3, b
    out     (c), a
    res     3, b
ENDIF
    inc     bc
    dec     e
    jr      nz, scroll_loop_2
    pop     bc
    pop     de
    ret


scrollup_hires:
    ld      bc, 32*8
    ld      hl, +(32*23*8)
scroll_hires_1:
    in      e, (c)
    dec     b
    out     (c), e
    inc     b
    inc     bc
    dec     hl
    ld      a, h
    or      l
    jr      nz, scroll_hires_1
    ld      l, 0
    xor     a
scrollup_hires_2:
    out     (c), a
    inc     bc
    dec     l
    jr      nz, scrollup_hires_2
    pop     bc
    pop     de
    ret

ENDIF