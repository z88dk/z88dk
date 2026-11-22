;
; Read the character in a cell: the pixels that differ from the pen of the top left pixel (the font keeps the left column and top row clear) are the glyph, bit reversed to the
; font's order; vpeek_screendollar matches it against the font and the UDGs.
;
; Entry: c = x, b = y, e = raw
; Exit:  nc = success, a = the character; c = failure
;
    SECTION code_driver
    PUBLIC  generic_console_vpeek
    EXTERN  generic_console_xypos
    EXTERN  vpeek_screendollar
    EXTERN  l_push_di
    EXTERN  l_pop_ei

generic_console_vpeek:
    call    generic_console_xypos       ;hl = the cell
    ld      c, l
    ld      b, h                        ;bc = the cell
    ld      hl, -8
    add     hl, sp
    ld      sp, hl                      ;the buffer: 8 bytes
    ld      hl, -16
    add     hl, sp
    ld      sp, hl                      ;the lines: plane I's 8, plane II's 8
    call    l_push_di
    in      a, ($e0)                    ;the video RAM in
    ld      hl, 2
    add     hl, sp
    ex      de, hl                      ;de = where the lines go
    ld      h, b
    ld      l, c                        ;hl = the cell
    ld      a, 1
    out     ($cd), a                    ;read plane I
    call    read_lines
    ld      h, b
    ld      l, c
    ld      a, 2
    out     ($cd), a                    ;read plane II
    call    read_lines
    in      a, ($e1)
    call    l_pop_ei
    push    ix
    ld      ix, 2
    add     ix, sp                      ;ix = the lines
    ld      a, (ix + 0)
    and     1
    neg
    ld      b, a                        ;b = $FF if plane I's top left pixel is set
    ld      a, (ix + 8)
    and     1
    neg
    ld      c, a                        ;c = plane II's
    ld      d, 8
glyph_loop:
    ld      a, (ix + 0)
    xor     b
    ld      e, a
    ld      a, (ix + 8)
    xor     c
    or      e                           ;set where the pixel is not the background
    ld      e, a
    xor     a
    REPT 8
    rr      e
    rla
    ENDR                                ;(to the font's bit order)
    ld      (ix + 16), a
    inc     ix
    dec     d
    jr      nz, glyph_loop
    pop     ix
    ld      hl, 16
    add     hl, sp
    ld      sp, hl                      ;the lines dropped: the buffer is on top
    ld      hl, 0
    add     hl, sp
    push    hl                          ;[the buffer's address][the buffer]
    jp      vpeek_screendollar          ;(drops the buffer and returns to the caller)

; 8 lines of 40 bytes apart from hl to de
read_lines:
    ld      a, 8
    ex      af, af
read_loop:
    ld      a, (hl)
    ld      (de), a
    inc     de
    ld      a, l
    add     a, 40
    ld      l, a
    jr      nc, no_carry
    inc     h
no_carry:
    ex      af, af
    dec     a
    jr      z, read_done
    ex      af, af
    jr      read_loop
read_done:
    ex      af, af
    ret
