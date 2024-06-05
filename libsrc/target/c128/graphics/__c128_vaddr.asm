
;       Graphics routines for the Commodore 128
;       Stefano - 2024 rework

    SECTION code_graphics

    PUBLIC __c128_vaddr


__c128_vaddr:
    ex      af, af
    ld      d, 18
    ld      bc, 0d600h
    out     (c), d
loop4:
    in      a, (c)
    rla
    jp      nc, loop4
    inc     c
    out     (c), h

    dec     c
    inc     d
    out     (c), d
loop5:
    in      a, (c)
    rla
    jp      nc, loop5
    inc     c
    out     (c), l

    dec     c
    ld      a, 31
    out     (c), a
loop6:
    in      a, (c)
    rla
    jp      nc, loop6
    inc     c
    ex      af, af
    ret
