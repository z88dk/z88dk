;
; Print a character in a cell: the 8x8 glyph from the font (32-127) or the UDGs (128-255), bit reversed to the screen's order, in the ink and paper pens.  Flags
; (generic_console_flags): bit 7 inverse (pens swapped), bit 4 bold (each line ORed with itself a pixel to the right), bit 3 underline (last line solid).
; Per plane the byte is (glyph & a) ^ x, a = $FF if ink and paper differ in that plane's bit, x = $FF if paper's bit is set.  The glyph, masks and cell address are on the
; stack while the video RAM is paged in, which hides the font and the console's variables if they are at $8000-$9FFF.
;
    SECTION code_driver
    PUBLIC  generic_console_printc
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  generic_console_flags
    EXTERN  generic_console_xypos
    EXTERN  __mz800_con_ink
    EXTERN  l_push_di
    EXTERN  l_pop_ei

; c = x
; b = y
; d = the character
; e = raw
generic_console_printc:
    ld      l, d
    ld      h, 0
    ld      de, (generic_console_font32)
    bit     7, l
    jr      z, not_udg
    res     7, l
    ld      de, (generic_console_udg32)
    inc     d
not_udg:
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, de
    dec     h                           ;(the font starts at character 32)
    push    hl                          ;[the glyph]
    call    generic_console_xypos       ;hl = the cell
    push    hl                          ;[the cell][the glyph]
    ld      a, (generic_console_flags)
    exx
    ld      c, a                        ;c' = the flags (bold, underline), kept for the glyph loop
    exx
    ld      hl, (__mz800_con_ink)       ;l = ink, h = paper
    rlca                                ;bit 7 = inverse
    jr      nc, not_inverse
    ld      a, l
    ld      l, h
    ld      h, a
not_inverse:
    ld      a, l
    xor     h
    ld      d, a                        ;d = the bits where the pens differ
    rrca
    sbc     a, a
    ld      b, a                        ;b = plane I's mask a
    ld      a, h
    rrca
    sbc     a, a
    ld      c, a                        ;c = plane I's x
    push    bc                          ;[a1 x1] (c at the lower address)
    ld      a, d
    rrca
    rrca
    sbc     a, a
    ld      b, a
    ld      a, h
    rrca
    rrca
    sbc     a, a
    ld      c, a
    push    bc                          ;[a2 x2][a1 x1][the cell][the glyph]: x2 +0, a2 +1, x1 +2, a1 +3, the cell +4, the glyph +6
    ld      hl, -8
    add     hl, sp
    ld      sp, hl                      ;the reversed glyph: +0..7, the others 8 higher
    call    l_push_di                   ;(a word more on the stack from here)
    ld      hl, 2 + 8 + 6
    add     hl, sp
    ld      e, (hl)
    inc     hl
    ld      d, (hl)                     ;de = the glyph
    ld      hl, 2
    add     hl, sp
    ex      de, hl                      ;hl = the glyph, de = the buffer
    ld      b, 8
reverse:
    ld      c, (hl)
    inc     hl
    exx
    bit     4, c                        ;bold
    exx
    jr      z, not_bold
    ld      a, c
    srl     a
    or      c
    ld      c, a
not_bold:
    ld      a, b
    dec     a
    jr      nz, not_last_line
    exx
    bit     3, c                        ;underline: the last line
    exx
    jr      z, not_last_line
    ld      c, $ff
not_last_line:
    xor     a
    REPT 8
    rr      c
    rla
    ENDR
    ld      (de), a
    inc     de
    djnz    reverse
    ld      hl, 2 + 8 + 4
    add     hl, sp
    ld      e, (hl)
    inc     hl
    ld      d, (hl)                     ;de = the cell
    in      a, ($e0)                    ;the video RAM in
    ld      a, 1
    out     ($cc), a                    ;plane I
    ld      hl, 2 + 8 + 2
    add     hl, sp
    ld      c, (hl)                     ;x1
    inc     hl
    ld      b, (hl)                     ;a1
    ld      hl, 2
    add     hl, sp
    call    draw_plane
    ld      a, 2
    out     ($cc), a                    ;plane II
    ld      hl, 2 + 8
    add     hl, sp
    ld      c, (hl)                     ;x2
    inc     hl
    ld      b, (hl)                     ;a2
    ld      hl, 2 + 8 + 4                ;(the cell again: draw_plane moved on de)
    add     hl, sp
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ld      hl, 2
    add     hl, sp
    call    draw_plane
    in      a, ($e1)                    ;the video RAM out
    call    l_pop_ei
    ld      hl, 8 + 4 + 4
    add     hl, sp
    ld      sp, hl                      ;(the glyph, the masks, the cell and the glyph pointer dropped)
    ret

; hl = the reversed glyph, de = the cell, b = a, c = x: 8 lines
draw_plane:
    REPT 8
    ld      a, (hl)
    inc     hl
    and     b
    xor     c
    ld      (de), a
    ld      a, e
    add     a, 40
    ld      e, a
    jr      nc, $+3
    inc     d
    ENDR
    ret
