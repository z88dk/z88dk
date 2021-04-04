
IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION code_graphics
    
    PUBLIC  xorborder
    PUBLIC  _xorborder
    
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

.xorborder
._xorborder
    push    ix
    ld      ix,2
    add     ix,sp
    ld      c,(ix+2)
    ld      b,(ix+4)
    ld      l,(ix+6)
    ld      h,(ix+8)
    pop     ix
    jp      asm_xorborder
ENDIF
