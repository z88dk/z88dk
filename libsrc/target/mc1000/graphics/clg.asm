;
;	MC-1000 graphics library
;
;	$Id: clg.asm $
;

;-----------  GFX init  -------------

    SECTION code_clib

    PUBLIC  ansi_cls
    PUBLIC  _ansi_cls
    PUBLIC  clg
    PUBLIC  _clg

    EXTERN  generic_console_ioctl
    EXTERN  generic_console_cls

    EXTERN  __mc6847_modeval
    INCLUDE "ioctl.def"


clg:
_clg:
ansi_cls:
_ansi_cls:
    ld      a, (__mc6847_modeval)
    and     @00011100
    cp      @00011100
    jp      z, generic_console_cls
    ld      hl, 1
    push    hl
    ld      hl, 0
    add     hl, sp
    ex      de, hl
    ld      a, IOCTL_GENCON_SET_MODE
    call    generic_console_ioctl
    pop     hl
    ret

