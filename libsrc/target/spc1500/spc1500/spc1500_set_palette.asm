; void spc1500_set_palette(uint8_t pen, uint8_t colour) __smallc
;
; Pen (0 to 7, the value of a pixel's three plane bits) to a colour (0 to 7: 1
; blue, 2 red, 4 green).  The palette is three registers, one a plane ($1000
; blue, $1100 red,
; $1200 green: write only), each with a bit for each pen: the bit is the plane's
; bit of the pen's colour.  The default is each pen its own colour.
    SECTION code_clib
    PUBLIC  spc1500_set_palette
    PUBLIC  _spc1500_set_palette
    PUBLIC  __spc1500_palette

spc1500_set_palette:
_spc1500_set_palette:
    ld      hl, 2
    add     hl, sp
    ld      d, (hl)                     ; the colour
    inc     hl
    inc     hl
    ld      a, (hl)                     ; the pen
    and     7
    ld      e, 1
    jr      z, mask_done
    ld      b, a
mask_loop:
    sla     e
    djnz    mask_loop
mask_done:                              ; e = the pen's bit
    ld      hl, __spc1500_palette
    ld      bc, $1000
plane_loop:
    ld      a, e
    cpl
    and     (hl)                        ; the register without the pen's bit
    rr      d                           ; the colour's bit for this plane
    jr      nc, bit_done
    or      e
bit_done:
    ld      (hl), a
    out     (c), a
    inc     hl
    ld      a, b
    add     a, $01
    ld      b, a
    cp      $13
    jr      nz, plane_loop
    ret

    SECTION bss_clib
__spc1500_palette:
    defs    3                           ; the registers as they were written (they cannot be read)
