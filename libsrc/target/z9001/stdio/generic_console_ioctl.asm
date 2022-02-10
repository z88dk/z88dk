
    MODULE  generic_console_ioctl
    PUBLIC  generic_console_ioctl

    SECTION code_clib
    INCLUDE "ioctl.def"

    EXTERN  generic_console_cls
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  __z9001_mode
    EXTERN  __console_w
    EXTERN  __console_h

    EXTERN  __CLIB_DISABLE_MODE1

    EXTERN  KRT_COLUMNS
    EXTERN  KRT_ROWS

    EXTERN  CONSOLE_ROWS
    EXTERN  CONSOLE_COLUMNS

    EXTERN  generic_console_caps
    PUBLIC  CLIB_GENCON_CAPS
    defc    CLIB_GENCON_CAPS = CAPS_MODE0

    defc    CAPS_MODE0 = CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR | CAP_GENCON_INVERSE
    defc    CAPS_MODE1 = CAP_GENCON_INVERSE | CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS | CAP_GENCON_BOLD | CAP_GENCON_UNDERLINE | CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR

; a = ioctl
; de = arg
generic_console_ioctl:
    ex      de,hl
    ld      c,(hl)	;bc = where we point to
    inc     hl
    ld      b,(hl)
    cp      IOCTL_GENCON_SET_FONT32
    jr      nz,check_set_udg
    ld      (generic_console_font32),bc
success:
    and     a
    ret
check_set_udg:
    cp      IOCTL_GENCON_SET_UDGS
    jr      nz,check_mode
    ld      (generic_console_udg32),bc
    jr      success
check_mode:
    cp      IOCTL_GENCON_SET_MODE
    jr      nz,failure
    ld      a,__CLIB_DISABLE_MODE1
    and     a
    jr      nz,failure
    ld      hl,+(CONSOLE_ROWS * 256) + CONSOLE_COLUMNS
    ld      a,c
    and	    a
    ld      d,CAPS_MODE0
    jr      z,set_mode
    cp	    1
    jr      nz,failure
    ld      hl,+(KRT_ROWS * 256) + KRT_COLUMNS
    ld      d,CAPS_MODE1
set_mode:
    ld      (__z9001_mode),a
    ld      (__console_w),hl
    ld      a,d
    ld      (generic_console_caps),a
    call    generic_console_cls
    jr      success
failure:
    scf
    ret
