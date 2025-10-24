
    MODULE  generic_console_ioctl
    PUBLIC  generic_console_ioctl

    SECTION code_clib

    EXTERN  generic_console_cls
    EXTERN  __console_h
    EXTERN  __console_w
    EXTERN  __console_font_h
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32

    INCLUDE "ioctl.def"

    EXTERN  generic_console_caps
    EXTERN  HECTOR_GRAPHICS_H
    PUBLIC  CLIB_GENCON_CAPS

    defc    CLIB_GENCON_CAPS=CAP_GENCON_INVERSE|CAP_GENCON_CUSTOM_FONT|CAP_GENCON_UDGS|CAP_GENCON_FG_COLOUR|CAP_GENCON_BG_COLOUR


; a = ioctl
; de = arg
generic_console_ioctl:
    ex      de, hl
    ld      c, (hl)                     ;bc = where we point to
    inc     hl
    ld      b, (hl)
    cp      IOCTL_GENCON_SET_FONT32
    jr      nz, check_set_udg
    ld      (generic_console_font32), bc
success:
    and     a
    ret
check_set_udg:
    cp      IOCTL_GENCON_SET_UDGS
    jr      nz, check_font_h
    ld      (generic_console_udg32), bc
    and     a
    ret
check_font_h:
IF FORhector1
    cp      IOCTL_GENCON_SET_FONT_H
    jr      nz, failure
    ld      a,c
    ld      b,HECTOR_GRAPHICS_H/8
    cp      8
    jr      z,set_fonth
    cp      6
    jr      nz,failure
    ld      b,HECTOR_GRAPHICS_H/6
set_fonth:
    ld      (__console_font_h),a
    ld      a,b
    ld      (__console_h),a
    and     a
    ret
ENDIF
failure:
    scf
    ret
