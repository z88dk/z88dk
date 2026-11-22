;
;       Tandy M100 ROM based graphics routines
;       Written by Stefano Bodrato 2026
;
;   -- scrollup_1px.asm -- 1 pixel scrollup
;
;
;

    section code_graphics
    PUBLIC  scrollup_1px
    PUBLIC  _scrollup_1px
    
    EXTERN  __gfx_coords
    EXTERN  __asm_pixeladdr
    INCLUDE "target/m100/def/romcalls.def"
    
    INCLUDE "classic/gfx/grafix.inc"


scrollup_1px:
_scrollup_1px:

    ld      d,0

hloop:
    push    de
    ld      c,0
    
    ld      e, _GFX_MAXY-8
vloop:
    push    de
    push    bc
    call    __asm_pixeladdr

    pop     bc
    ld      a,c
    rra
    ld      a,(hl)
    rra
    push    af
    adc     a                  ; save CY on bit 0
    ld      c,a                ; and keep it on C reg
    pop     af
    push    bc

    ROMCALL
    defw KY_LCDSET_TAIL        ; write data
    pop     bc
    pop     de

    ld      a,e
    sub     8
    ld      e,a
    jr      nc,vloop
    
    pop     de
    inc     d
    ld      a,_GFX_MAXX
    cp      d
    jr      nz,hloop
    
    ret
