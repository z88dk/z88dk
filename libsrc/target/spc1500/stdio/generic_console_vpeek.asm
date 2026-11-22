;
; Read the character in a cell: the pixels that differ from the pen of the top
; left pixel (the font keeps the left column and top row clear) are the glyph,
; ORed over the three
; planes; vpeek_screendollar matches it against the font and the UDGs.
;
; Entry: c = x, b = y, e = raw
; Exit:  nc = success, a = the character; c = failure
;
    SECTION code_clib
    PUBLIC  generic_console_vpeek
    EXTERN  generic_console_xypos
    EXTERN  vpeek_screendollar

generic_console_vpeek:
    call    generic_console_xypos       ;hl = the cell's offset
    ld      a, h
    add     a, $40
    ld      h, a                        ;the first line in the blue plane
    ld      (vp_cell), hl
    ld      hl, 0
    push    hl
    push    hl
    push    hl
    push    hl                          ;the buffer: 8 bytes, 0
    add     hl, sp
    ex      de, hl                      ;de = the buffer
    ld      hl, (vp_cell)
    ld      a, 3
    ld      (vp_planes), a
vp_plane:
    ld      b, h
    ld      c, l
    in      a, (c)                      ;the plane's first line
    rlca
    sbc     a, a                        ;$FF if the top left pixel is set: the background
    ld      (vp_bg), a
    ld      a, 8
    ld      (vp_lines), a
vp_line:
    ld      b, h
    ld      c, l
    in      a, (c)
    ld      c, a
    ld      a, (vp_bg)
    xor     c                           ;set where the pixel is not the background
    ld      c, a
    ld      a, (de)
    or      c
    ld      (de), a
    inc     de
    ld      a, h
    add     a, 8
    ld      h, a
    ld      a, (vp_lines)
    dec     a
    ld      (vp_lines), a
    jr      nz, vp_line
    ld      a, e                        ;(the buffer again)
    sub     8
    ld      e, a
    jr      nc, vp_noborrow
    dec     d
vp_noborrow:
    ld      a, (vp_planes)
    dec     a
    ld      (vp_planes), a
    jr      nz, vp_plane                ;(eight lines on: hl is the next plane's first line)
    ld      hl, 0
    add     hl, sp
    push    hl                          ;[the buffer's address][the buffer]
    jp      vpeek_screendollar          ;(drops the buffer and returns to the caller)

    SECTION bss_clib
vp_cell:    defw    0
vp_planes:  defb    0
vp_lines:   defb    0
vp_bg:      defb    0
