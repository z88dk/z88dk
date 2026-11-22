

    SECTION code_clib

    PUBLIC  pixeladdress_MODE0
    PUBLIC  pixeladdress_MODE1
    PUBLIC  pixeladdress_MODE2

    defc    SCREEN = 49152


; Address = 0xC000 + ((Line / 8) * 80) + ((Line % 8) * 2048
pixeladdress_MODE0:
    call   pixeladdress
    ;hl = start of row,
    ;de = x
    ld     a,e
    rrca
    and     @01111111
    add     l
    ld      l,a
    ld      a,0
    adc     h
    ld      h,a
    ld      a,e
    and     1
    ret


pixeladdress_MODE1:
    call   pixeladdress
    ;hl = start of row,
    ;de = x
    ld      a,e
    srl     d
    rra
    srl     d
    rra
    and     @01111111
    add     l
    ld      l,a
    ld      a,0
    adc     h
    ld      h,a
    ld      a,e
    and     3
    ret


pixeladdress_MODE2:
    call    pixeladdress
    ;hl = start of row,
    ;de = x
    ld      a,e
    srl     d
    rra
    srl     d
    rra
    srl     d
    rra
    add     l
    ld      l,a
    ld      a,0
    adc     h
    ld      h,a
    ld      a,e
    xor     7
    and     7
    ret



pixeladdress:
    ; Scale hl to screen mode
    ex      de,hl
    ld      b,l

    ld      a,b
    and     @11111000
    ld      l,a
    ld      h,0        ;hl = 8 * (Line / 8 )
    ld      a,b        ;Save y for a bit
    add     hl,hl        ;hl = 16 * (Line / 8 )
    ld      c,l
    ld      b,h
    add     hl,hl
    add     hl,hl        ;64 *
    add     hl,bc        ;80 *

    and     @00000111
    rlca
    rlca
    rlca    ;*8
    add     h
    add     +(SCREEN / 256)
    ld      h,a
    ret
