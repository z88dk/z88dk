

    SECTION code_graphics

    PUBLIC  pixeladdress_MODE3
    EXTERN  SCREEN_BASE
    EXTERN  __gfx_fatpix


; Entry: hl = x
;        de = y
; Exit: hl = addr
;    a = pixel offset
;    z = pixel @1100000
pixeladdress_MODE3:
    ld      a,(__gfx_fatpix)
    and     a
    jr      z,not_fatpix
    add     hl,hl
not_fatpix:
    ex      de,hl
    ld      a,h
    ld      h,l    ;x128
    ld      l,0
    rra
    rr      h
    rr      l
    ld      a,e     ;save x (lowest byte)
    ; Divide x by 4 to get the byte
    srl     d
    rr      e
    srl     e
    ld      d,+(SCREEN_BASE / 256)
    add     hl,de
    and     3
    ret	
