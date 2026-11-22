; PC-6001mkII 320x200 console and graphics (mode MC6847_MODE_MK2 = 3 of
; classic/video/mc6847): two bit planes, plane 0 at the screen's base (the crt's
; __pc6001mk2_vram: $C000 for the disc, $8000 for a cartridge) and plane 1 $2000
; on, 40 bytes a pixel row, the leftmost pixel of a byte its bit 7; a pixel's
; pen is its plane 0 bit + 2 * its plane 1 bit, and the four pens are the
; colours of the set $C0 chooses (the default set 4 is green, yellow, blue, red:
; -pragma-define:CRT_PC6001MK2_COLOURSET=n).  The console is 40x25 cells of 8x8
; pixels, a cell its glyph in the ink pen over the paper pen.
; In pc6001mk2.lib, linked ahead of pc6001_clib by -subtype=mk2disc, so these
; replace the do-nothing stubs the PC-6001 has.

    SECTION     code_driver
    PUBLIC      __pc6001mk2_printc
    EXTERN      generic_console_font32
    EXTERN      generic_console_udg32
    EXTERN      generic_console_flags
    EXTERN      __pc6001mk2_xypos
    EXTERN      __pc6001mk2_ink
    EXTERN      __pc6001mk2_paper

; The glyph (8 bytes, the leftmost pixel in bit 7) from the font (characters 32
; to 127) or the UDGs (128 to 255), in the ink over the paper pen (swapped if
; the inverse flag is set).
; In a plane the ink and the paper bits are each 0 or 1, so the plane's eight
; bytes are one of four things: zeros, ones, the glyph or its complement.
;
; c = x, b = y, d = the character, e = raw
__pc6001mk2_printc:
    ld          l, d
    ld          h, 0
    ld          de, (generic_console_font32)
    bit         7, l
    jr          z, not_udg
    res         7, l
    ld          de, (generic_console_udg32)
    inc         d
not_udg:
    add         hl, hl
    add         hl, hl
    add         hl, hl
    add         hl, de
    dec         h                       ; (the font starts at character 32)
    push        hl                      ; the glyph
    call        __pc6001mk2_xypos       ; hl = the cell
    ex          de, hl                  ; de = the cell
    pop         hl                      ; hl = the glyph
    ld          a, (generic_console_flags)
    rlca                                ; bit 7 = inverse
    ld          a, (__pc6001mk2_ink)
    ld          c, a
    ld          a, (__pc6001mk2_paper)
    ld          b, a
    jr          nc, not_inverse
    ld          a, c
    ld          c, b
    ld          b, a
not_inverse:                            ; b = the paper pen, c = the ink pen
    push        bc
    ; the plane 0 selector: the ink's bit 0 + 2 * the paper's bit 0
    ld          a, b
    and         1
    add         a, a
    ld          b, a
    ld          a, c
    and         1
    or          b
    push        hl
    push        de
    call        plane
    pop         de
    pop         hl
    pop         bc
    ; plane 1: the ink's bit 1 + the paper's bit 1 (already in place)
    ld          a, b
    and         2
    ld          b, a
    ld          a, c
    rrca
    and         1
    or          b
    ld          b, a
    ld          a, d
    add         a, $20                  ; (plane 1 is $2000 on)
    ld          d, a
    ld          a, b
; plane: a = 0 zeros, 1 the glyph, 2 its complement, 3 ones; hl = the glyph, de
; = the plane's cell
plane:
    ex          de, hl                  ; hl = the cell, de = the glyph
    ld          bc, 40
    and         a
    jr          z, pl_zero
    dec         a
    jr          z, pl_copy
    dec         a
    jr          z, pl_comp
    ld          a, $ff
    jr          pl_fill
pl_zero:
    xor         a
pl_fill:
    REPT        7
    ld          (hl), a
    add         hl, bc
    ENDR
    ld          (hl), a
    ret
pl_copy:
    REPT        7
    ld          a, (de)
    inc         de
    ld          (hl), a
    add         hl, bc
    ENDR
    ld          a, (de)
    ld          (hl), a
    ret
pl_comp:
    REPT        7
    ld          a, (de)
    inc         de
    cpl
    ld          (hl), a
    add         hl, bc
    ENDR
    ld          a, (de)
    cpl
    ld          (hl), a
    ret
