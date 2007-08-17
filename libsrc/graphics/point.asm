;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;       $Id: point.asm,v 1.4 2007-08-17 13:52:33 stefano Exp $
;


;Usage: point(struct *pixel)
;Result is true/false


                XLIB    point

                LIB     pointxy
                LIB     swapgfxbk
                LIB     swapgfxbk1


.point
                ld      ix,0
                add     ix,sp
                ld      l,(ix+2)
                ld      h,(ix+4)
                call    swapgfxbk
                call    pointxy
                push    af
                call    swapgfxbk1
                pop     af
                ld      hl,1
                ret     nz       ;pixel set
                dec     hl
                ret

