;
; Read the character in a cell: the pixels in the ink colour (the paper colour if inverse is set) are the glyph, which is looked for in the font
; and then in the UDGs.
;
; Entry: c = x, b = y, e = raw
; Exit:  nc = success, a = the character; c = failure
;
    SECTION code_clib
    PUBLIC  __mz2500_gfxcon_vpeek
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  generic_console_flags
    EXTERN  generic_console_xypos
    EXTERN  __mz2500_glyph_reverse
    EXTERN  __mz2500_con_glyph
    EXTERN  __mz2500_con_ink
    EXTERN  __mz2500_gwin_save
    EXTERN  __mz2500_gwin_map
    EXTERN  __mz2500_gwin_restore
    EXTERN  l_push_di
    EXTERN  l_pop_ei
    EXTERN  __MZ2500_GFX_PAGE

__mz2500_gfxcon_vpeek:
    call    generic_console_xypos       ;hl = the cell
    call    l_push_di
    push    hl
    call    __mz2500_gwin_save
    ld      hl, __mz2500_con_glyph
    ld      de, __mz2500_con_glyph + 1
    ld      (hl), $ff
    ld      bc, 7
    ldir                                ;(the glyph starts as all pixels and loses those that are not the ink in some plane)
    exx
    ld      a, (generic_console_flags)
    ld      hl, (__mz2500_con_ink)      ;l = ink, h = paper
    rlca
    jr      nc, not_inverse
    ld      l, h
not_inverse:
    ld      d, l                        ;d' = the ink bits: bit 0 = this plane
    ld      h, __MZ2500_GFX_PAGE        ;h' = the plane's page
plane_loop:
    ld      a, d
    rrca
    sbc     a, a
    cpl
    ld      c, a                        ;c = $FF if the ink has this plane's bit clear (the pixels to match are the clear ones)
    ld      a, h
    call    __mz2500_gwin_map
    push    bc
    exx
    pop     bc
    pop     hl
    push    hl
    ld      de, __mz2500_con_glyph
    REPT 8
    ld      a, (hl)
    xor     c
    ld      b, a
    ld      a, (de)
    and     b
    ld      (de), a
    inc     de
    ld      a, l
    add     a, 40
    ld      l, a
    jr      nc, $+3
    inc     h
    ENDR
    exx
    srl     d
    inc     h
    inc     h
    ld      a, h
    cp      __MZ2500_GFX_PAGE + 8
    jp      nz, plane_loop
    exx
    pop     hl
    call    __mz2500_gwin_restore
    call    l_pop_ei
    ld      hl, __mz2500_con_glyph
    ld      d, h
    ld      e, l
    call    __mz2500_glyph_reverse      ;(to the font's bit order)
    ld      hl, (generic_console_font32)
    ld      c, 32
    ld      b, 96
    call    search
    ret     nc
    ld      hl, (generic_console_udg32)
    ld      a, h
    or      l
    jr      z, not_found
    ld      c, 128
    ld      b, 128
search:
    push    bc                          ;b = how many characters, c = the first
    push    hl                          ;hl = the first glyph
    ld      de, __mz2500_con_glyph
    ld      b, 8
compare:
    ld      a, (de)
    cp      (hl)
    jr      nz, no_match
    inc     de
    inc     hl
    djnz    compare
    pop     hl
    pop     bc
    ld      a, c
    and     a                           ;nc
    ret
no_match:
    pop     hl
    ld      de, 8
    add     hl, de
    pop     bc
    inc     c
    djnz    search
not_found:
    scf
    ret
