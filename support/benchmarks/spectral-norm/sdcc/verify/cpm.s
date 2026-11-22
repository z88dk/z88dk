.area _CODE

_putchar::

    ; E = char

    push    ix
    push    iy

    ld      e,a
    ld      c,#2
    call    #0x0005

    pop     iy
    pop     ix

    ret

_getchar::

    push    ix
    push    iy

    ld      c,#1
    call    #0x0005

    pop     iy
    pop     ix

    ret
