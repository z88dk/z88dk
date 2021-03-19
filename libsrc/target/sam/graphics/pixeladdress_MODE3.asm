

    SECTION code_graphics

    PUBLIC  pixeladdress_MODE3
    EXTERN  SCREEN_BASE


; Entry: hl = x
;        de = y
; Exit: hl = addr
;    a = pixel offset
;    z = pixel @1100000
pixeladdress_MODE3:
    ex      de,hl
    add     hl,hl   ;*2
    add     hl,hl   ;*4
    add     hl,hl   ;*8
    add     hl,hl   ;*16
    add     hl,hl   ;*32
    add     hl,hl   ;*64
    add     hl,hl   ;*128
    ld      c,e     ;save x (lowest byte)
    ; Divide x by 4 to get the byte
    srl     d
    rr      e
    srl     d
    rr      e
    ld      a,d
    or      +(SCREEN_BASE / 256)
    ld      d,a
    add     hl,de
    ld      a,c
    and     3
    ret	
