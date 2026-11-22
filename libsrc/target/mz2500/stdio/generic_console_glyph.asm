;
; The glyphs of the fonts are one byte a line with the leftmost pixel in bit 7; the screen's bytes have it in bit 0.  The console works on a copy of the
; glyph (or of the pixels it has read) with the bits reversed.
;
    SECTION code_clib
    PUBLIC  __mz2500_glyph_reverse
    PUBLIC  __mz2500_con_glyph

; hl = the 8 bytes to reverse, de = where to put them (may be the same).  Uses af, bc, de, hl
__mz2500_glyph_reverse:
    ld      b, 8
reverse_loop:
    ld      a, (hl)
    inc     hl
    REPT 8
    rra
    rl      c
    ENDR
    ld      a, c
    ld      (de), a
    inc     de
    djnz    reverse_loop
    ret

    SECTION bss_clib
__mz2500_con_glyph: defs    8
