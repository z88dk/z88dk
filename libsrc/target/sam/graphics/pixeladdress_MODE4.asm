

    SECTION code_graphics

    PUBLIC  pixeladdress_MODE4
    EXTERN  SCREEN_BASE


; Entry: h = y
;        l = x
; Exit: hl = addr
;       a = pixel offset
;       z = pixel @111100000
pixeladdress_MODE4:
    ; Multiple row by 128
    ld      a,l	;Save x
    ld      l,0
    srl     h
    rr      l
    ; Now we need to divide the pixel by 2 (4 pxs per byte)
    ld      c,a
    srl     c
    ld      b,+(SCREEN_BASE / 256)
    add     hl,bc
    and     1
    ret	
