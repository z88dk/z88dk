

    SECTION code_clib
    PUBLIC  generic_console_ioctl

    EXTERN  __console_w
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  __fp1100_mode

    INCLUDE "target/fp1100/def/fp1100.def"
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
success:
    and     a
    ret
check_set_udg:
    cp      IOCTL_GENCON_SET_UDGS
    jr      nz, failure
    ld      (generic_console_udg32), bc
    jr      success
failure:
    scf
    ret