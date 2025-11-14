
    INCLUDE "classic/video/mc6847/mc6847.inc"

IFDEF MC6847_IOSPACE

    SECTION code_driver

    PUBLIC  vpeek_MODE2
    EXTERN  vpeek_screendollar
    EXTERN  __mc6847_MODE2_attr

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


    ld      a, c
    add     c
    ld      c, a
    jr      nc, @no_overflow
    inc     b
@no_overflow:

    ld      a,255
    ld      (__vpeek_colour),a
   
    ld      a, 8
@row_loop:
    ex      af, af
    push    hl                          ;save buffer
    ld      e, 0                        ;resulting byte
    ld      a, 2                        ;we need to do this loop twice
@nibble_loop:
    push    af
    ld      l, @11000000
    ld      a,(__vpeek_colour)
    ld      h,a
    ld      d, 4                        ;4 pixels in a byte
@bit_loop:
    ld      a,h
    inc     a
    jr      nz,@got_paper
    in      a,(c)
    and     l
    ld      h,a
    ld      (__vpeek_colour),a
@got_paper:
    in      a, (c)
    and     l                           ;resets carry
    cp      h
    scf
    jr      nz,@rotate_in_bit
    ccf
@rotate_in_bit:
    rl      e
    ;; Rotate the mask and testing
    srl     h
    srl     h
    srl     l
    srl     l
    dec     d
    jr      nz, @bit_loop
    inc     bc
    pop     af
    dec     a
    jr      nz, @nibble_loop
    pop     hl                          ;buffer
    ld      (hl), e
    inc     hl
    ld      a, c
    add     30
    ld      c, a
    jr      nc, @no_overflow2
    inc     b
@no_overflow2:
    ex      af, af
    dec     a
    jr      nz, @row_loop
    jp      vpeek_screendollar

    SECTION bss_driver

__vpeek_colour: defb    0

ENDIF