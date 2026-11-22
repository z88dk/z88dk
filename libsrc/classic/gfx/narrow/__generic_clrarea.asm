

    SECTION code_graphics
    PUBLIC  __generic_clrarea
    EXTERN  respixel

;
;    $Id: __generic_clrarea.asm $
;

; ***********************************************************************
;
; Clear specified graphics area in map.
; Generic version
;
; Stefano Bodrato - March 2002
;
;
; IN:    HL    = (x,y)
;    BC    = (width,heigth)
;

__generic_clrarea:

    push    hl
    push    bc
rowloop:
    push    hl
    push    de
    push    bc
    call    respixel
    pop     bc
    pop     de
    pop     hl

    inc     h
    djnz    rowloop
    pop     bc
    pop     hl
    inc     l
    dec     c
    jr      nz, __generic_clrarea
    ret
