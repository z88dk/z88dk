
;

PUBLIC __generic_w_incx

SECTION code_graphics


__generic_w_incx:
    push    af

    ld      a, 16
    add     e
    ld      e, a
    jr      nc, gonehi
    inc     d
gonehi:

    ld      a, 16
    add     l
    ld      l, a
    jr      nc, gonehi2
    inc     h
gonehi2:


    pop af
    ret

