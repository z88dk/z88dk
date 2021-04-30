
    SECTION    code_clib
    PUBLIC    pixeladdress

    INCLUDE    "graphics/grafix.inc"


; ******************************************************************
;
; Get absolute    pixel address in map of virtual (x,y) coordinate.
;
; in:  hl    = (x,y) coordinate of pixel (h,l)
;
; out: de    = address    of pixel byte
;       a    = bit number of byte where pixel is to be placed
;      fz    = 1 if bit number is 0 of pixel position

.pixeladdress
    ; Multiple y by 30 add (x/8)
    ex      de,hl
    ld      l,e
    ld      h,0
    ld      c,l
    ld      b,h
    add     hl,hl    ;*2
    add     hl,hl    ;*4
    add     hl,bc    ;*5
    ld      c,l
    ld      b,h
    add     hl,hl    ;*10
    add     hl,bc    ;*15
    add     hl,hl    ;*30
    ld      a,d
    rrca
    rrca
    rrca
    and     31
    ld      c,a
    ld      b, 0xe0  ;VRAM base address
    add     hl,bc    ;Now we have the "character square"
    ld      a,d
    ex      de,hl    ;de = address
    and     7
    xor     7
    ret
