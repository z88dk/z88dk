
    MODULE  generic_console_ioctl
    PUBLIC  generic_console_ioctl

    SECTION code_clib

    EXTERN  generic_console_cls
    EXTERN  __console_w
    EXTERN  __pc8001_mode
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  generic_console_caps
    EXTERN  __CLIB_PC8001_HIRES
    EXTERN  __pc8001_hires_setmode

    INCLUDE "ioctl.def"

    PUBLIC  CLIB_GENCON_CAPS
    defc    CLIB_GENCON_CAPS=CAP_GENCON_INVERSE|CAP_GENCON_BOLD|CAP_GENCON_UNDERLINE
    ; In a hires mode text can be bitmapped once a font has been set
    defc    CLIB_GENCON_CAPS_HIRES=CLIB_GENCON_CAPS|CAP_GENCON_CUSTOM_FONT|CAP_GENCON_UDGS
    defc    CLIB_GENCON_CAPS_HIRES4=CLIB_GENCON_CAPS_HIRES|CAP_GENCON_FG_COLOUR|CAP_GENCON_BG_COLOUR

; Modes:
;   0 = 80x25 text, 160x100 semigraphics
;   1 = 40x25 text, 80x100 semigraphics
;   2 = 80x25 text, 640x200 mono graphics        (-clib=mk2)
;   3 = 40x25 text, 320x200 4 colour graphics    (-clib=mk2)
;
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
    jr      nz, check_mode
    ld      (generic_console_udg32), bc
    jr      success
check_mode:
    cp      IOCTL_GENCON_SET_MODE
    jr      nz, failure
    ld      a, c
    and     31
    ld      d, 0                        ;d = graphics mode
    ld      bc, $1950                   ;25 rows, 80 columns
    jr      z, set_mode
    cp      1
    ld      bc, $1928                   ;25 rows, 40 columns
    jr      z, set_mode
    ld      e, a                        ;The remaining modes are hires
    ld      a, __CLIB_PC8001_HIRES
    and     a
    jr      z, failure
    ld      a, e
    cp      2
    ld      bc, $1950
    ld      d, 1
    jr      z, set_mode
    cp      3
    ld      bc, $1928
    ld      d, 2
    jr      nz, failure
set_mode:
    ld      a, c                        ;a = 1 for 40 columns
    cp      80
    sbc     a, a
    and     1
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
    ld      a, d
    call    __pc8001_hires_setmode
    ld      a, d
    and     a
    ld      a, CLIB_GENCON_CAPS
    jr      z, set_caps                 ;no graphics
    ld      a, d
    cp      2
    ld      a, CLIB_GENCON_CAPS_HIRES
    jr      nz, set_caps
    ld      a, CLIB_GENCON_CAPS_HIRES4
set_caps:
    ld      (generic_console_caps), a
    call    generic_console_cls
    and     a
    ret
failure:
    scf
    ret
