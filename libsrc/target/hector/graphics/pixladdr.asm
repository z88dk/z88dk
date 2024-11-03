;

;-----------  GFX paging  -------------

    SECTION code_clib

    PUBLIC  pixeladdress

    INCLUDE "target/hector/def/hector1.def"


; Entry  h = x
;        l = y
; Exit: de = address
;	hl = x,y
;	 a = pixel number (0-3 counting)
; Uses: a, de
pixeladdress:
    push    hl
	; add y-times the nuber of bytes per line (32)
	; or just multiply y by 32 and the add
    ld      e, h
    ld      h, 0
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, hl
IF FORhector2
    add     hl,hl
ENDIF
    ld      a, e                        ;4 pixels per byte
    srl     e
    srl     e
    ld      d, +(HEC_SCREEN/256)
    add     hl, de
    ex      de, hl
    pop     hl
    and     3
    xor     3
    ret
