;
; 	Video handling for the Sharp PC G-800 family
;
;	Stefano Bodrato - 2025
;
;	-- scrollup_4px.asm -- 4 pixel scrollup
;
;
;

    section code_graphics
    PUBLIC  scrollup_4px
    PUBLIC  _scrollup_4px
    
    EXTERN setx
    EXTERN sety
    
    INCLUDE "graphics/grafix.inc"


scrollup_4px:
_scrollup_4px:

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
    
    ld      d,a
    and     $f0
    rra
    rra
    rra
    rra
    
    or      e
    
    push    hl
    call    sety
    call    setx
    pop     hl
    exx
    out     (c), a                   ;write data  (auto-increment)
    exx
    
    ld      a,d
    and     $0f
    rla
    rla
    rla
    rla
    ld      e,a
    
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
