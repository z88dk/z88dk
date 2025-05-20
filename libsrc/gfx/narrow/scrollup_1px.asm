;
; Scroll 1 pixel up
;
;
; Generic version, Stefano Bodrato - 2025
;
;
; $Id: scrollup_1px.asm $
;

IF  !__CPU_INTEL__&!__CPU_GBZ80__

    PUBLIC  scrollup_1px
    PUBLIC  _scrollup_1px
    PUBLIC  ___scrollup_1px
    EXTERN  pointxy
    EXTERN  plotpixel
    EXTERN  respixel

    INCLUDE "graphics/grafix.inc"

scrollup_1px:
_scrollup_1px:
___scrollup_1px:

    ld      c,1
loopy:
    ld      b,maxx
loopx:

    push    bc
    ld      h,b
	dec     h
    ld      l,c
    push    hl
    call    pointxy
    pop     hl

    push    af
    dec     l
    pop     af

    jr      z,unplot
    call    plotpixel
    jr      plot
unplot:
    call    respixel
plot:

    pop     bc
    djnz    loopx
    inc     c
    ld      a,maxy
    cp      c
    jr      nz,loopy

    ld      b,maxx
loopb:
    ld      h,b
	dec     h
    ld      l,maxy-1
    push    bc
    call    respixel
    pop     bc
    djnz    loopb

    ret


ENDIF
