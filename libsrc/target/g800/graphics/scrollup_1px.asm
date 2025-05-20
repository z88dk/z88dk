;
; 	Video handling for the Sharp PC G-800 family
;
;	Stefano Bodrato - 2025
;
;	-- scrollup_1px.asm -- 4 pixel scrollup
;
;
;

    section code_graphics
    PUBLIC  scrollup_1px
    PUBLIC  _scrollup_1px
    
    EXTERN setx
    EXTERN sety
    
    INCLUDE "graphics/grafix.inc"


scrollup_1px:
_scrollup_1px:

    ld      h,0

hloop:
    ld      e,0
    push     hl
    
    ld      l, maxy-8
vloop:
    push    hl
    call    sety
    call    setx
    pop     hl
    
    in      a, (c)                   ;dummy read
    in      a, (c)                   ;read data
    
    rr      e
    rra
    rl      e
    
    push    hl
    call    sety
    call    setx
    pop     hl
    exx
    out     (c), a                   ;write data  (auto-increment)
    exx
    
    ld      a,l
    sub     8
    ld      l,a
    jr      nc,vloop
    
    pop     hl
    inc     h
    ld      a,maxx
    cp      h
    jr      nz,hloop
    
    ret
