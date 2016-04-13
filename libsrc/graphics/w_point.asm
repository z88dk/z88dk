;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;
;	$Id: w_point.asm,v 1.3 2016-04-13 21:09:09 dom Exp $
;


;Usage: point(struct *pixel)
;Result is true/false


        SECTION code_clib
                PUBLIC    point

                EXTERN     w_pointxy
                EXTERN     swapgfxbk
                EXTERN     swapgfxbk1


.point
._point
		pop	bc
		pop	de
		pop	hl
		push	hl
		push	de
		push	bc

                call    swapgfxbk
                call    w_pointxy
                push    af
                call    swapgfxbk1
                pop     af
                ld      hl,1
                ret     nz       ;pixel set
                dec     hl
                ret
