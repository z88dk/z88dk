
    SECTION code_graphics

    PUBLIC  drawbox
    INCLUDE "classic/gfx/grafix.inc"

;
;    $Id: drawbox.asm $
;

; ***********************************************************************
;
; Draw a box.
; Generic version
;
; Stefano Bodrato - March 2002
;
;
; IN:    HL    = (x,y)
;    BC    = (width,heigth)
;

drawbox:
    push    bc
    push    hl

; -- Vertical lines --
    push    hl
    ld      a, h
    add     a, b
    dec     a
    ld      h, a
    pop     de
rowloop:
    push    bc

    call    p_sub
    inc     l
    ex      de, hl

    call    p_sub
    inc     l
    ex      de, hl

    pop     bc
    dec     c
    jr      nz, rowloop

    pop     hl
    pop     bc

; -- Horizontal lines --
    inc     h
    dec     b
    dec     b
    push    hl
    ld      a, l
    add     a, c
    dec     a
    ld      l, a
    pop     de

vrowloop:
    push    bc

    call    p_sub
    inc     h
    ex      de, hl

    call    p_sub
    inc     h
    ex      de, hl

    pop     bc

    djnz    vrowloop

    ret

p_sub:
    push    hl
    push    de

IF  !__CPU_INTEL__&!__CPU_GBZ80__

    ld      de, plot_RET
    push    de
    jp      (ix)                        ;    execute PLOT at (h,l)

ELSE

    EXTERN  __plot_ADDR

    ld      de, plot_RET
    push    de                          ;    hl =    (x0,y0)...
    ld      de, (__plot_ADDR)
	push    de
    ret                                 ;    execute PLOT at (x0,y0)

ENDIF

plot_RET:
    pop     de
    pop     hl
    ret
