
    SECTION code_driver

    PUBLIC  pixeladdress
    EXTERN  pixeladdress_MODE1
    EXTERN  pixeladdress_MODE2

    EXTERN  __mc6847_mode

    INCLUDE "video/mc6847/mc6847.inc"


; Entry  h = x
;        l = y
; Exit: hl = address
;	 a = pixel number
; Uses: a, bc, de, hl
pixeladdress:
    ld      a, (__mc6847_mode)
    and     0xfd
IF MC6847_HAS_HIRES
    cp      MODE_HIRES & 0xfd
    jp      z, pixeladdress_MODE1
ENDIF
    cp      MODE_MULTICOLOUR & 0xfd
    jp      z, pixeladdress_MODE2
    ret


IF FORmc1000

    EXTERN  __mc6847_mode
    PUBLIC  pixelbyte
    PUBLIC  pix_return

pix_return:

    ex      af, af                      ; dcircle uses the flags in af'.. watch out !
    ld      a, (__mc6847_mode)
    out     ($80), a

    ex      af, af                      ; dcircle uses the flags in af'.. watch out !
    ld      (de), a                     ; pixel address

    ld      a, (__mc6847_mode)
    set     0, a
    out     ($80),a
    ret


    ; Needs to stay in code_driver
    PUBLIC  pixelbyte
pixelbyte:  defb    0
ENDIF