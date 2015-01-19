;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;       $Id: point.asm,v 1.5 2015-01-19 01:32:46 pauloscustodio Exp $
;


;Usage: point(struct *pixel)
;Result is true/false


                PUBLIC    point

                EXTERN     pointxy
                EXTERN     swapgfxbk
                EXTERN     swapgfxbk1


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

