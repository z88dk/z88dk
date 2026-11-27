
    MODULE  generic_console_ioctl
    PUBLIC  generic_console_ioctl

    SECTION code_clib

    EXTERN  generic_console_cls
    EXTERN  __console_w
    EXTERN  __pc8001_mode

    INCLUDE "ioctl.def"

    PUBLIC  CLIB_GENCON_CAPS
    defc    CLIB_GENCON_CAPS=CAP_GENCON_INVERSE|CAP_GENCON_BOLD|CAP_GENCON_UNDERLINE

; a = ioctl
; de = arg
generic_console_ioctl:
    ex      de, hl
    ld      c, (hl)                     ;bc = where we point to
    inc     hl
    ld      b, (hl)
    cp      IOCTL_GENCON_SET_MODE
    jr      nz, failure
    ld      a, c
    and     31
    ld      bc, $1950                   ;25 rows, 80 columns
    jr      z, set_mode
    cp      1
    jr      nz, failure
    ld      bc, $1928                   ;25 rows, 40 columns
set_mode:
    ld      (__pc8001_mode), a
    ld      (__console_w), bc
    ld      hl, $ea66                   ;N-BASIC's copy of port $30
    res     0, (hl)                     ;40 columns
    and     a
    jr      nz, out_mode
    set     0, (hl)                     ;80 columns
out_mode:
    ld      a, (hl)
    out     ($30), a
    call    generic_console_cls
    and     a
    ret
failure:
    scf
    ret
