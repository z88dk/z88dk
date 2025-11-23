
    SECTION code_driver

    PUBLIC  pixeladdress
    EXTERN  pixeladdress_MODE1
    EXTERN  pixeladdress_MODE2

    EXTERN  __mc6847_mode

    INCLUDE "classic/video/mc6847/mc6847.inc"


; Entry  h = x
;        l = y
; Exit: hl = address
;	 a = pixel number
; Uses: a, bc, de, hl
pixeladdress:
    ld      a, (__mc6847_mode)
    and     a
IF MC6847_HAS_HIRES
    cp      1
    jp      z, pixeladdress_MODE1
ENDIF
    cp      2
    jp      z, pixeladdress_MODE2
    ret


IF FORmc1000

    EXTERN  __mc6847_modeval
    PUBLIC  pixelbyte
    PUBLIC  pix_return

pix_return:

    ex      af, af                      ; dcircle uses the flags in af'.. watch out !
    ld      a, (__mc6847_modeval)
    res     0,a
    out     ($80), a

    ex      af, af                      ; dcircle uses the flags in af'.. watch out !
    ld      (de), a                     ; pixel address

    ld      a, (__mc6847_modeval)
    set     0, a
    out     ($80),a
    ret

    PUBLIC  pixelbyte
pixelbyte:  defb    0
ENDIF