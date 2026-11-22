    INCLUDE "classic/video/mc6847/mc6847.inc"

IFDEF MC6847_IOSPACE

    SECTION code_driver
    PUBLIC  generic_console_cls

    EXTERN  __spc1000_attr
    EXTERN  __tms9918_cls
    EXTERN  __mc6847_mode



generic_console_cls:
    ld      a, (__mc6847_mode)
    and     a
    jr      z, cls_text
IF FORspc1000
    cp      10
    jp      z, __tms9918_cls
ENDIF
    jr      cls_hires
cls_text:
    ld      bc, 0
    ld      hl, MC6847_CONSOLE_ROWS*MC6847_CONSOLE_COLUMNS
cls_1:
    ld      a, ' '
    out     (c), a
IF FORspc1000
    set     3, b
    ld      a, (__spc1000_attr)
    out     (c), a
    res     3, b
ENDIF
    inc     bc
    dec     hl
    ld      a, h
    or      l
    jr      nz, cls_1
    ret

cls_hires:
    ld      bc, 0
    ld      hl, +(32*24*8)
    ld      e, 0
cls_hires_1:
    out     (c), e
    inc     bc
    dec     hl
    ld      a, h
    or      l
    jr      nz, cls_hires_1
    ret

ENDIF