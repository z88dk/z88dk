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
    PUBLIC      __pc6001mk2_vpeek
    EXTERN      __pc6001mk2_xypos
    EXTERN      vpeek_screendollar

; The character in a cell: the 8 lines of each plane are copied to the stack,
; the cell's background is the pen of its top left pixel (the font keeps that
; pixel clear), the glyph is the pixels that differ from it in either plane, and
; vpeek_screendollar finds it in the font and the UDGs.
;
; Entry: c = x, b = y, e = raw.   Exit: nc = success, a = the character; c =
; failure
__pc6001mk2_vpeek:
    ld          hl, -24
    add         hl, sp
    ; [plane 0: 8] [plane 1: 8] [the glyph: 8] [the return]
    ld          sp, hl
    call        __pc6001mk2_xypos       ; hl = the cell
    ex          de, hl
    ld          hl, 0
    add         hl, sp
    ex          de, hl                  ; de = the stack, hl = the cell
    ld          b, 8
read0:
    ld          a, (hl)
    ld          (de), a
    inc         de
    ld          a, l
    add         a, 40
    ld          l, a
    jr          nc, no0
    inc         h
no0:
    djnz        read0
    ld          bc, $2000-320
    ; (back up the 8 lines, and on to plane 1)
    add         hl, bc
    ld          b, 8
read1:
    ld          a, (hl)
    ld          (de), a
    inc         de
    ld          a, l
    add         a, 40
    ld          l, a
    jr          nc, no1
    inc         h
no1:
    djnz        read1
    push        ix
    ld          ix, 2
    add         ix, sp                  ; ix = plane 0's lines
    ld          a, (ix+0)
    rlca
    sbc         a, a
    ; $FF if the background's plane 0 bit is set
    ld          b, a
    ld          a, (ix+8)
    rlca
    sbc         a, a
    ld          c, a
    ld          a, (ix+0)
    xor         b
    ld          d, a
    ld          a, (ix+8)
    xor         c
    or          d
    ld          (ix+16), a
    ld          a, (ix+1)
    xor         b
    ld          d, a
    ld          a, (ix+9)
    xor         c
    or          d
    ld          (ix+17), a
    ld          a, (ix+2)
    xor         b
    ld          d, a
    ld          a, (ix+10)
    xor         c
    or          d
    ld          (ix+18), a
    ld          a, (ix+3)
    xor         b
    ld          d, a
    ld          a, (ix+11)
    xor         c
    or          d
    ld          (ix+19), a
    ld          a, (ix+4)
    xor         b
    ld          d, a
    ld          a, (ix+12)
    xor         c
    or          d
    ld          (ix+20), a
    ld          a, (ix+5)
    xor         b
    ld          d, a
    ld          a, (ix+13)
    xor         c
    or          d
    ld          (ix+21), a
    ld          a, (ix+6)
    xor         b
    ld          d, a
    ld          a, (ix+14)
    xor         c
    or          d
    ld          (ix+22), a
    ld          a, (ix+7)
    xor         b
    ld          d, a
    ld          a, (ix+15)
    xor         c
    or          d
    ld          (ix+23), a
    pop         ix
    ld          hl, 16
    add         hl, sp
    ; (the planes dropped: the glyph is next to the return)
    ld          sp, hl
    push        hl                      ; the buffer's address
    jp          vpeek_screendollar
