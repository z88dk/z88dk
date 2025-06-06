
    MODULE  generic_console_ioctl
    PUBLIC  generic_console_ioctl

    SECTION code_clib

    EXTERN  generic_console_cls
    EXTERN  __console_h
    EXTERN  __console_w
    EXTERN  __mc6847_mode
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32

    INCLUDE "video/mc6847/mc6847.inc"
    INCLUDE "ioctl.def"

    EXTERN  generic_console_caps
    PUBLIC  CLIB_GENCON_CAPS
    defc    CLIB_GENCON_CAPS=CAPS_MODE0

        ; Text
    defc    CAPS_MODE0=CAP_GENCON_INVERSE|CAP_GENCON_FG_COLOUR|CAP_GENCON_BG_COLOUR
        ; Hires
    defc    CAPS_MODE1=CAP_GENCON_INVERSE|CAP_GENCON_CUSTOM_FONT|CAP_GENCON_UDGS
        ; Colour
    defc    CAPS_MODE2=CAP_GENCON_INVERSE|CAP_GENCON_CUSTOM_FONT|CAP_GENCON_UDGS|CAP_GENCON_FG_COLOUR|CAP_GENCON_BG_COLOUR|CAP_GENCON_UNDERLINE|CAP_GENCON_BOLD


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
    ld      a, c                        ; The mode
    and     31
    ld      e, 32                       ;columns
    ld      h, MODE_0
    ld      d, CAPS_MODE0
    ld      l, 16
    and     a
    jr      z, set_mode
    ld      h, MODE_1
    ld      d, CAPS_MODE1
    ld      l, 24
    cp      1                           ;HIRES
    jr      z, set_mode
    ld      e, 16
    ld      h, MODE_2
    ld      d, CAPS_MODE1
    cp      2                           ;Half hires
    jr      nz, failure
set_mode:
    bit     5, c
    jr      z, not_css
    set     1, h
not_css:
    ld      a, e
    ld      (__console_w), a
    ld      a, l
    ld      (__console_h), a
    ld      a, d
    ld      (generic_console_caps), a
    ld      a, h
    ld      (__mc6847_mode), a
    IF  FORmc1000
        out     ($80), a
        ld      ($f5), a                    ;Keep basic up-to-date with mode
        ld      hl, dummy_return
        ld      ($f7), hl                   ; cursor flashing and positioning routine
    ELIF FORpc6001
        ;; MC6947 registers are memory mapped as first byte
        ld      hl,(SYSVAR_screen-1)
        ld      l,0
        ld      (hl),a
    ELIF FORsv8000
        out     ($c0), a
    ELIF FORvz
        ld      ($783b), a                  ;SYS VAR
        ld      ($6800), a                  ;Latch
    ELIF __SPC1000__
        ld      bc, $2000
        out     (c), a
    ENDIF
    call    generic_console_cls
    and     a
    ret
failure:
    scf
dummy_return:
    ret
