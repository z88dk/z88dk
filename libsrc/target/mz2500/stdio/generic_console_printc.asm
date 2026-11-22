;
; Print a character in a cell: the 8x8 glyph (bit-reversed to the screen's order), from the font (characters 32-127) or the UDGs (128-255), in the ink and paper colours (swapped if the
; inverse flag is set).  The four planes are written a plane at a time: for each plane, byte = (glyph & a) ^ x with a = ink and paper bits differ,
; x = the paper bit.
;
    SECTION code_clib
    PUBLIC  __mz2500_gfxcon_printc
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

; c = x
; b = y
; d = the character
; e = raw
__mz2500_gfxcon_printc:
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
    push    bc
    ld      de, __mz2500_con_glyph
    call    __mz2500_glyph_reverse      ;(the font has the leftmost pixel in bit 7, the screen in bit 0)
    pop     bc
    call    generic_console_xypos       ;hl = the cell
    call    l_push_di
    push    hl                          ;the cell: copied for each plane
    call    __mz2500_gwin_save
    exx
    ld      a, (generic_console_flags)
    ld      hl, (__mz2500_con_ink)      ;l = ink, h = paper
    rlca                                ;bit 7 = inverse
    jr      nc, not_inverse
    ld      a, l
    ld      l, h
    ld      h, a
not_inverse:
    ld      d, l                        ;d' = ink bits, e' = paper bits: bit 0 = this plane
    ld      e, h
    ld      h, __MZ2500_GFX_PAGE        ;h' = the plane's page
plane_loop:
    ld      a, d
    xor     e
    rrca
    sbc     a, a
    ld      b, a                        ;b = $FF if the ink and paper bits differ
    ld      a, e
    rrca
    sbc     a, a
    ld      c, a                        ;c = $FF if the paper bit is set
    ld      a, h
    call    __mz2500_gwin_map
    push    bc
    exx
    pop     bc
    pop     hl
    push    hl
    ld      de, __mz2500_con_glyph
    REPT 8
    ld      a, (de)
    and     b
    xor     c
    ld      (hl), a
    inc     de
    ld      a, l
    add     a, 40
    ld      l, a
    jr      nc, $+3
    inc     h
    ENDR
    exx
    srl     d
    srl     e
    inc     h
    inc     h
    ld      a, h
    cp      __MZ2500_GFX_PAGE + 8
    jp      nz, plane_loop
    exx
    pop     hl
    call    __mz2500_gwin_restore
    call    l_pop_ei
    ret
