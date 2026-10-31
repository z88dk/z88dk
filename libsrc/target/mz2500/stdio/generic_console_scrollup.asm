;
; Scroll the console up a line (8 lines of pixels), one plane at a time, and clear the bottom line to the paper colour
;
    SECTION code_clib
    PUBLIC  __mz2500_gfxcon_scrollup
    EXTERN  __mz2500_gwin_save
    EXTERN  __mz2500_gwin_map
    EXTERN  __mz2500_gwin_restore
    EXTERN  __mz2500_con_paper
    EXTERN  l_push_di
    EXTERN  l_pop_ei
    EXTERN  __MZ2500_GFX_BASE
    EXTERN  __MZ2500_GFX_PAGE

__mz2500_gfxcon_scrollup:
    push    de
    push    bc
    ld      a, (__mz2500_con_paper)
    ld      c, a
    ld      b, __MZ2500_GFX_PAGE
scroll_plane:
    call    l_push_di                   ;(off for a plane at a time, about 28 ms)
    call    __mz2500_gwin_save
    ld      a, b
    call    __mz2500_gwin_map
    ld      hl, __MZ2500_GFX_BASE + 320
    ld      de, __MZ2500_GFX_BASE
    push    bc
    ld      bc, 24 * 320
    ldir
    pop     bc
    ld      a, c
    rrca
    ld      c, a                        ;the paper colour's bit for this plane is in the carry
    sbc     a, a
    ld      l, e
    ld      h, d
    ld      (de), a
    inc     de
    push    bc
    ld      bc, 319
    ldir
    pop     bc
    call    __mz2500_gwin_restore
    call    l_pop_ei
    inc     b
    inc     b
    ld      a, b
    cp      __MZ2500_GFX_PAGE + 8
    jr      nz, scroll_plane
    pop     bc
    pop     de
    ret
