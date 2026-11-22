    INCLUDE "classic/video/mc6847/mc6847.inc"

IFNDEF MC6847_IOSPACE


    SECTION code_driver

    PUBLIC  vpeek_MODE2
    EXTERN  vpeek_screendollar
    EXTERN  __mc6847_modeval
    EXTERN  __mc6847_MODE2_attr
    EXTERN  generic_console_gfx_xypos_MODE2
    EXTERN  __console_font_h

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
    call    generic_console_gfx_xypos_MODE2

    ex      de, hl
    ld      a,255
    ld      (__vpeek_colour),a
    ld      a, (__console_font_h)
    ld      b, a
IF FORmc1000
    ld      a, (__mc6847_modeval)
    ex      af, af
ENDIF
@row_loop:
    push    bc
    push    hl                          ;save buffer
    ld      c, 0                        ;resulting byte
    ld      a, 2                        ;we need to do this loop twice
@nibble_loop:
    push    af
    ld      l, @11000000
    ld      a,(__vpeek_colour)
    ld      h,a
    ld      b, 4                        ;4 pixels in a byte
@bit_loop:
IF FORmc1000
    ex      af, af
    res     0, a
    out     ($80), a                    ;VRAM in
    ex      af, af
    ld      a,h
    inc     a
    jr      nz,@got_paper
    ld      a,(de)
    and     l
    ld      h,a
    ld      (__vpeek_colour),a
@got_paper:
    ld      a, (de)
    ex      af, af
    set     0, a
    out     ($80), a                    ;VRAM out
    ex      af, af
ELSE
    ld      a,h
    inc     a
    jr      nz,@got_paper
    ld      a,(de)
    and     l
    ld      h,a
    ld      (__vpeek_colour),a
@got_paper:
    ld      a, (de)
ENDIF
    and     l                           ; resets carry
    cp      h
    scf
    jr      nz,@rotate_in_bit           ;it's not the background pen
    ccf
@rotate_in_bit:
    rl      c
    srl     h
    srl     h
    srl     l
    srl     l
    djnz    @bit_loop
    inc     de
    pop     af
    dec     a
    jr      nz, @nibble_loop
    pop     hl                          ;buffer
    ld      (hl), c
    inc     hl
    dec     de
    dec     de
    ld      a, e
    add     32
    ld      e, a
    jr      nc, @no_overflow
    inc     d
@no_overflow:
    pop     bc
    djnz    @row_loop
    jp      vpeek_screendollar

    SECTION bss_driver

__vpeek_colour: defb    0

ENDIF

