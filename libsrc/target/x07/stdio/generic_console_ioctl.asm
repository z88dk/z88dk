

    SECTION code_clib
    PUBLIC  generic_console_ioctl

    EXTERN  __console_w
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  __x07_natural_chars
    EXTERN  CONSOLE_COLUMNS
    EXTERN  CONSOLE_ROWS
    EXTERN  generic_console_cls

    INCLUDE "ioctl.def"

    PUBLIC  CLIB_GENCON_CAPS
    defc    CLIB_GENCON_CAPS=CAP_GENCON_UDGS | CAP_GENCON_CUSTOM_FONT

generic_console_ioctl:
    ex      de, hl
    ld      c, (hl)                     ;bc = where we point to
    inc     hl
    ld      b, (hl)
    cp      IOCTL_GENCON_SET_FONT32
    jr      nz, check_set_udg
    ld      (generic_console_font32), bc
    and     a
    ret
check_set_udg:
    cp      IOCTL_GENCON_SET_UDGS
    jr      nz, check_font_height
    ld      (generic_console_udg32), bc
    and     a
    ret
check_font_height:
    cp      IOCTL_GENCON_SET_FONT_H
    jr      nz, failure
    ld      a,c
    ld      hl, +(( CONSOLE_ROWS << 8) | CONSOLE_COLUMNS) * 2
    ld      b,0
    cp      4
    jr      z,set_height
    ld      hl, +(( CONSOLE_ROWS << 8) | CONSOLE_COLUMNS)
    inc     b
set_height:
    ld      (__console_w),hl
    ld      a,b
    ld      (__x07_natural_chars),a
    call    generic_console_cls
    and     a
    ret
failure:
    scf
    ret
