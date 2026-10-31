;
; Read the character in a cell (graphics console): the pixels in the ink colour are the glyph, which is matched against the font and the UDGs by
; vpeek_screendollar (it also matches a glyph that was printed inverse).
;
; Entry: c = x, b = y, e = raw
; Exit:  nc = success, a = the character; c = failure
;
    SECTION code_clib
    PUBLIC  __mz2500_gfxcon_vpeek
    EXTERN  generic_console_xypos
    EXTERN  __mz2500_glyph_reverse
    EXTERN  vpeek_screendollar
    EXTERN  __mz2500_con_ink
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
    ld      hl, -8
    add     hl, sp
    ld      sp, hl                      ;the 8 byte buffer: starts as all pixels and loses those that are not the ink in some plane
    push    hl                          ;(its address, for vpeek_screendollar)
    ld      (hl), $ff
    ld      d, h
    ld      e, l
    inc     de
    push    bc
    ld      bc, 7
    ldir
    pop     hl                          ;hl = the cell
    call    l_push_di
    push    hl                          ;[the cell] [the status] [the buffer's address]
    call    __mz2500_gwin_save
    exx
    ld      a, (__mz2500_con_ink)
    ld      d, a                        ;d' = the ink bits: bit 0 = this plane
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
    ld      hl, 4
    add     hl, sp
    ld      e, (hl)
    inc     hl
    ld      d, (hl)                     ;de = the buffer
    pop     hl
    push    hl                          ;hl = the cell
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
    pop     hl                          ;(the cell)
    call    __mz2500_gwin_restore
    call    l_pop_ei
    pop     hl
    push    hl                          ;the buffer
    ld      d, h
    ld      e, l
    call    __mz2500_glyph_reverse      ;(to the font's bit order)
    jp      vpeek_screendollar
