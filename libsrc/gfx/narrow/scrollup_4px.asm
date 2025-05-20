;
; Scroll 4 pixel up
;
;
; Generic version, Stefano Bodrato - 2025
;
;
; $Id: scrollup_4px.asm $
;

IF  !__CPU_INTEL__&!__CPU_GBZ80__

    PUBLIC  scrollup_4px
    PUBLIC  _scrollup_4px
    PUBLIC  ___scrollup_4px
    EXTERN  pointxy
    EXTERN  plotpixel
    EXTERN  respixel

    INCLUDE "graphics/grafix.inc"

scrollup_4px:
_scrollup_4px:
___scrollup_4px:

    ld      c,4
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
    dec     l
    dec     l
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

	ld      c,4
loopc:
    ld      b,maxx
loopb:
    ld      h,b
	dec     h
	ld      a,maxy
	sub     c
    ld      l,a
    push    bc
    call    respixel
    pop     bc
    djnz    loopb
	dec     c
	jr      nz,loopc

    ret


ENDIF
