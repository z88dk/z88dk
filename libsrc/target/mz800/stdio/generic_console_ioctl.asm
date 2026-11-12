;
; Console ioctls: the font (characters 32-127) and the UDGs (128-255) are pointers to 8 bytes a character, the font starting at character 32 and the UDGs at 128.  The screen is
; the 320x200 graphics (40 x 25 characters): there are no other modes.
;
    MODULE  generic_console_ioctl
    SECTION code_clib
    PUBLIC  generic_console_ioctl
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32

    INCLUDE "ioctl.def"

    PUBLIC  CLIB_GENCON_CAPS
    defc    CLIB_GENCON_CAPS=CAP_GENCON_FG_COLOUR|CAP_GENCON_BG_COLOUR|CAP_GENCON_INVERSE|CAP_GENCON_CUSTOM_FONT|CAP_GENCON_UDGS|CAP_GENCON_BOLD|CAP_GENCON_UNDERLINE

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
    jr      nz, failure
    ld      (generic_console_udg32), bc
    jr      success
failure:
    scf
    ret
