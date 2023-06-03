
SECTION code_clib

PUBLIC  w_pointxy

EXTERN  __agon_gfxh
EXTERN  __agon_gfxw
EXTERN  l_cmp
EXTERN  __agon_putc
EXTERN  __gfx_coords
EXTERN  __agon_putword
EXTERN  __agon_bgcol

INCLUDE "target/agon/def/mos_api.inc"


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


    push    ix
    MOSCALL(mos_sysvars)
    defb    $5b     ;LIL
    res     2,(ix+sysvar_vpd_pflags)


    ld      a,23
    call    __agon_putc
    xor     a
    call    __agon_putc
    ld      a,$84
    call    __agon_putc
    call    __agon_putword
    ex      de,hl
    call    __agon_putword

ck:
    defb    $5b     ;LIL
    bit     2,(ix+sysvar_vpd_pflags)
    jr      z,ck
    defb    $5b     ;LIL
    ld      a,(ix+ sysvar_scrpixelIndex)
    and     a
    pop     ix
    pop     bc
    ret
