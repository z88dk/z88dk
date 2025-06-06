;

;-----------  GFX paging  -------------

    SECTION code_clib

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
    cp      MODE_1
    jp      z, pixeladdress_MODE1
    cp      MODE_2
    jp      z, pixeladdress_MODE2
    ret
