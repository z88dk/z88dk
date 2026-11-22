;
; 	Video handling for the Sharp PC G-800 family
;
;	Stefano Bodrato - 2026
;
;	-- scrollup_6px.asm -- 6 pixel scrollup
;
;
;

    section code_graphics
    PUBLIC  scrollup_6px
    PUBLIC  _scrollup_6px
    
    EXTERN setx
    EXTERN sety
    
    INCLUDE "classic/gfx/grafix.inc"


scrollup_6px:
_scrollup_6px:

    ld      h,0

hloop:
    ld      e,0
    push     hl
    
    ld      l, _GFX_MAXY-8
vloop:
    push    hl
    call    sety
    call    setx
    pop     hl
    
    in      a, (c)                   ;dummy read
    in      a, (c)                   ;read data
    
    ld      d,a
    rlca
    rlca
    and     $03
    
    or      e
    
    push    hl
    call    sety
    call    setx
    pop     hl
    exx
    out     (c), a                   ;write data  (auto-increment)
    exx
    
    ld      a,d
    rla
    rla
    and     $fc
    ld      e,a
    
    ld      a,l
    sub     8
    ld      l,a
    jr      nc,vloop
    
    pop     hl
    inc     h
    ld      a,_GFX_MAXX
    cp      h
    jr      nz,hloop
    
    ret
