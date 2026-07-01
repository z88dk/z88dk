
    SECTION code_graphics

    PUBLIC  xorborder
    PUBLIC  _xorborder
    PUBLIC  ___xorborder

    EXTERN  asm_xorborder

;
;    $Id: xorborder.asm $
;

; ***********************************************************************
;
; XORs a dotted box.  Useful for GUIs.
; Generic version
;
; Stefano Bodrato - March 2002
;
;
; IN:    HL    = (x,y)
;    BC    = (width,heigth)
;

xorborder:
_xorborder:
___xorborder:

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix
    ld      ix, 2
    add     ix, sp
    ld      c, (ix+2)
    ld      b, (ix+4)
    ld      l, (ix+6)
    ld      h, (ix+8)
    pop     ix
ELSE
    pop     af
    pop     bc                          ; height
    pop     de
    ld      b, e                        ; width

    pop     hl                          ; x
    pop     de
    push    de
    push    hl
    ld      h, e                        ; y

    push    de                          ; foo value, the original one is gone
    push    bc
    push    af
ENDIF
    jp      asm_xorborder
