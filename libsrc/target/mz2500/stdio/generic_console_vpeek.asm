;
; Entry: c = x, b = y, e = raw
; Exit:  nc = success, a = the character; c = failure
;
    SECTION code_clib
    PUBLIC  __mz2500_gfxcon_vpeek
    EXTERN  generic_console_xypos
    EXTERN  __mz2500_glyph_reverse
    EXTERN  vpeek_screendollar
    EXTERN  __mz2500_gwin_save
    EXTERN  __mz2500_gwin_map
    EXTERN  __mz2500_gwin_restore
    EXTERN  l_push_di
    EXTERN  l_pop_ei
    EXTERN  __MZ2500_GFX_PAGE

__mz2500_gfxcon_vpeek:
    call    generic_console_xypos       ;hl = the cell
    ld      c, l
    ld      b, h                        ;bc = the cell
    ld      hl, -32
    add     hl, sp
    ld      sp, hl                      ;32 bytes: the 8 lines of each plane (plane 0 first)
    call    l_push_di
    push    bc                          ;[the cell] [the status] [the lines]
    call    __mz2500_gwin_save
    ld      hl, 4
    add     hl, sp
    ex      de, hl                      ;de = where the lines go
    ld      b, __MZ2500_GFX_PAGE        ;b = the plane's page
plane_loop:
    ld      a, b
    call    __mz2500_gwin_map
    pop     hl
    push    hl                          ;hl = the cell
    REPT 8
    ld      a, (hl)
    ld      (de), a
    inc     de
    ld      a, l
    add     a, 40
    ld      l, a
    jr      nc, $+3
    inc     h
    ENDR
    inc     b
    inc     b
    ld      a, b
    cp      __MZ2500_GFX_PAGE + 8
    jp      nz, plane_loop
    pop     hl                          ;(the cell)
    call    __mz2500_gwin_restore
    call    l_pop_ei                    ;now the 32 bytes are at the top of the stack

    ld      hl, 0
    add     hl, sp                      ;hl = the lines
    ld      de, 24
    add     hl, de                      ;the first line of plane 3
    ld      de, -8
    ld      b, 0
    REPT 4
    ld      a, (hl)
    rrca                                ;carry = the leftmost pixel (bit 0)
    rl      b                           ;(plane 3 first, so plane 0 ends in bit 0)
    add     hl, de
    ENDR
    ld      a, b
    or      16
    ld      b, a                        ;b = the background colour | 16
    ld      hl, got_char
    push    hl                          ;(where vpeek_screendollar returns to)
    ld      hl, -8
    add     hl, sp
    ld      sp, hl
    push    hl                          ;[the buffer's address] [the buffer] [got_char] [the lines]
    ex      de, hl                      ;de = the buffer
    ld      hl, 12
    add     hl, sp                      ;hl = the lines
    call    build                       ;(bit set where the pixel is the background)
    pop     hl
    push    hl                          ;hl = the buffer
    ld      b, 8
invert_loop:
    ld      a, (hl)
    cpl
    ld      (hl), a
    inc     hl
    djnz    invert_loop
    pop     hl
    push    hl
    ld      d, h
    ld      e, l
    call    __mz2500_glyph_reverse      ;(to the font's bit order)
    jp      vpeek_screendollar          ;(drops the buffer, returns to got_char)

got_char:
    ex      af, af
    ld      hl, 32
    add     hl, sp
    ld      sp, hl                      ;(drop the lines)
    ex      af, af
    ret

; Make the buffer: bit set where the pixel is in the colour.  hl = the lines, de = the buffer, b = the colour | 16 (the 16 ends the loop)
; Uses af, bc, de, hl
build:
    push    de
    ld      a, $ff
    REPT 8
    ld      (de), a
    inc     de
    ENDR
    pop     de
build_plane:
    srl     b                           ;carry = this plane's bit of the colour
    sbc     a, a
    cpl
    ld      c, a                        ;c = $ff if the colour's bit is clear (the pixels to match are the clear ones)
    push    de
    REPT 8
    ld      a, (hl)
    inc     hl
    xor     c
    ex      de, hl
    and     (hl)
    ld      (hl), a
    inc     hl
    ex      de, hl
    ENDR
    pop     de
    ld      a, b
    dec     a                           ;(b = 1 when the four planes are done)
    jr      nz, build_plane
    ret
