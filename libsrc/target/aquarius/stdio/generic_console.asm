;



    SECTION		code_clib

    PUBLIC		generic_console_cls
    PUBLIC		generic_console_scrollup
    PUBLIC		generic_console_printc

    EXTERN      printc_BITMAP
    EXTERN      printc_TEXT
    EXTERN      cls_BITMAP
    EXTERN      cls_TEXT
    EXTERN      scrollup_BITMAP
    EXTERN      scrollup_TEXT

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
