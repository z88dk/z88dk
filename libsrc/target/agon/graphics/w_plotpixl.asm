
SECTION code_clib

PUBLIC  w_plotpixel

EXTERN  __agon_gfxh
EXTERN  __agon_gfxw
EXTERN  l_cmp
EXTERN  __agon_putc
EXTERN  __gfx_coords
EXTERN  __agon_putword
EXTERN  __agon_fgcol


w_plotpixel:
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
    ; Set graphics colour
    ld      a,18
    call    __agon_putc
    xor     a           ;graphic mode
    call    __agon_putc
    ld      a,(__agon_fgcol)
    call    __agon_putc
    ; VDU 25, n, 640; 512;
    ld      a,25
    call    __agon_putc
    ld      a,$41
    call    __agon_putc
    call    __agon_putword
    ex      de,hl
    call    __agon_putword
    pop     bc
    ret
