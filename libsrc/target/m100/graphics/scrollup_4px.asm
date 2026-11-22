;
;       Tandy M100 ROM based graphics routines
;       Written by Stefano Bodrato 2026
;
;   -- scrollup_4px.asm -- 4 pixel scrollup
;
;
;

    section code_graphics
    PUBLIC  scrollup_4px
    PUBLIC  _scrollup_4px
    
    EXTERN  __gfx_coords
    EXTERN  __asm_pixeladdr
    INCLUDE "target/m100/def/romcalls.def"
    
    INCLUDE "classic/gfx/grafix.inc"


scrollup_4px:
_scrollup_4px:

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
    
    ld      a,(hl)                   ; read data

    ld      e,a
    rra
    rra
    rra
    rra
    and     $0f
    or      c

	push    af
    ld      a,e
    rla
    rla
    rla
    rla
    and     $f0
    ld      c,a
	pop     af
    
    push    bc
    ROMCALL
    defw KY_LCDSET_TAIL              ; write data
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
