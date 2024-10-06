;


    INCLUDE "target/aquarius/def/aqplus.def"

    SECTION		code_clib

    PUBLIC		generic_console_cls
    PUBLIC		generic_console_scrollup
    PUBLIC		generic_console_printc

    EXTERN  CLIB_AQUARIUS_PLUS

    EXTERN      printc_BITMAP
    EXTERN      printc_TEXT
    EXTERN      cls_BITMAP
    EXTERN      cls_TEXT
    EXTERN      scrollup_BITMAP
    EXTERN      scrollup_TEXT

    EXTERN      generic_console_ioctl

    EXTERN      __aquarius_mode

    INCLUDE     "ioctl.def"
    PUBLIC  CLIB_GENCON_CAPS
    defc    CLIB_GENCON_CAPS = CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR 



generic_console_cls:
    ld      hl,__aquarius_mode
    bit     0,(hl)
    push    hl
    call    nz,cls_TEXT
    pop     hl
    bit     2,(hl)
    call    nz,cls_BITMAP
    ret



; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
    ld      hl,__aquarius_mode
    bit     0,(hl)
    jp      nz,printc_TEXT
    bit     2,(hl)
    jp      nz,printc_BITMAP
    ret




generic_console_scrollup:
    ld      hl,__aquarius_mode
    bit     0,(hl)
    jp      nz,scrollup_TEXT
    bit     2,(hl)
    jp      nz,scrollup_BITMAP
    ret


    SECTION code_crt_init

    EXTERN  set_default_palette

    ; On an Aquarius+ we modify the caps so that we can define the font
    ld      c, CLIB_AQUARIUS_PLUS
    rr      c
    jr      nc, not_plus

    call    set_default_palette

    ; Remap the border color character for aqplus
    in      a, (IO_VCTRL)
    or      VCTRL_REMAP_BC
    ld      de, __aquarius_mode
    ld      (de), a
    ld      a, IOCTL_GENCON_SET_MODE
    ; This will setup the mode and screen size
    ; so that it matches the hardware during init.
    call    generic_console_ioctl
not_plus:
