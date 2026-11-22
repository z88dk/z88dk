; The all-RAM console's ioctl: a font (glyphs 32 to 127, 8 bytes each, sent to the sub program at once), the UDG table (128 on, sent as they are printed), and
; the mode (only the 40 column one exists).

    MODULE  fp1100_allram_generic_console_ioctl
    SECTION code_clib

    PUBLIC  generic_console_ioctl
    PUBLIC  CLIB_GENCON_CAPS
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  fp1100_sub_font

    INCLUDE "ioctl.def"

    defc    CLIB_GENCON_CAPS=CAP_GENCON_FG_COLOUR|CAP_GENCON_BG_COLOUR|CAP_GENCON_INVERSE

generic_console_ioctl:
    ex      de, hl
    ld      c, (hl)                     ;bc = where we point to
    inc     hl
    ld      b, (hl)
    cp      IOCTL_GENCON_SET_FONT32
    jr      nz, check_set_udg
    ld      (generic_console_font32), bc
    call    fp1100_sub_font
success:
    and     a
    ret
check_set_udg:
    cp      IOCTL_GENCON_SET_UDGS
    jr      nz, check_set_mode
    ld      (generic_console_udg32), bc
    jr      success
check_set_mode:
    cp      IOCTL_GENCON_SET_MODE
    jr      nz, failure
    ld      a, c
    and     1
    jr      z, success                  ; 40 columns
failure:
    scf
    ret
