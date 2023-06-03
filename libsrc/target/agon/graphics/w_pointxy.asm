
SECTION code_clib

PUBLIC  w_pointxy

EXTERN  __agon_gfxh
EXTERN  __agon_gfxw
EXTERN  l_cmp
EXTERN  __agon_putc
EXTERN  __gfx_coords
EXTERN  __agon_putword
EXTERN  __agon_bgcol


w_pointxy:
    push	hl		;save x
    ld      hl,(__agon_gfxh)
    inc     hl
    call    l_cmp
    pop     hl
    ret     nc

    ex      de,hl		;de = x, hl = y
    push    hl		;save y
    ld      hl,(__agon_gfxw)
    inc     hl
    call    l_cmp
    pop     hl
    ret     nc
    ex      de,hl
    ld      (__gfx_coords),hl	;x
    ld      (__gfx_coords+2),de	;y
    push    bc
    
    ;; TODO
    pop     bc
    ret

