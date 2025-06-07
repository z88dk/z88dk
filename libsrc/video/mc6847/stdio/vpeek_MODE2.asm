IF !MC6847_IOSPACE


    SECTION code_clib

    PUBLIC  vpeek_MODE2
    EXTERN  vpeek_screendollar
    INCLUDE "video/mc6847/mc6847.inc"


;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
vpeek_MODE2:
    ld      hl, -8
    add     hl, sp
    ld      sp, hl
    push    hl                          ;Save buffer
    ex      de, hl                      ;get it into de
    GETSCREENADDRESS
    ld      l,c
    add     hl,bc


        ; b7   b6   b5   b4   b3   b2   b1   b0
         ; p0-1 p1-1 p2-1 p3-1 p0-0 p1-0 p2-0 p3-0
    ex      de, hl
    ld      b, 8
IF FORmc1000
    ld      a, (__mc1000_modeval)
    ex      af, af
ENDIF
handle_MODE2_per_line:
    push    bc
    push    hl                          ;save buffer
    ld      h, @10000000
    ld      c, 0                        ;resulting byte
    ld      a, 2                        ;we need to do this loop twice
handle_mode1_nibble:
    push    af
    ld      l, @11000000
    ld      b, 4                        ;4 pixels in a byte
handle_MODE2_0:
IF FORmc1000
    ex      af, af
    res     0, a
    out     ($80), a                    ;VRAM in
    ex      af, af
    ld      a, (de)
    ex      af, af
    set     0, a
    out     ($80), a                    ;VRAM out
    ex      af, af
    and     l
    jr      z, not_set
    ld      a, c
    or      h
    ld      c, a

ELSE
    ld      a, (de)
    and     l
    jr      z, not_set
    ld      a, c
    or      h
    ld      c, a
ENDIF
not_set:
    srl     h
    srl     l
    srl     l
    djnz    handle_MODE2_0
    inc     de
    pop     af
    dec     a
    jr      nz, handle_mode1_nibble
    pop     hl                          ;buffer
    ld      (hl), c
    inc     hl
    dec     de
    dec     de
    ld      a, e
    add     32
    ld      e, a
    jr      nc, no_overflow_MODE2
    inc     d
no_overflow_MODE2:
    pop     bc
    djnz    handle_MODE2_per_line
    jp      vpeek_screendollar

ENDIF

