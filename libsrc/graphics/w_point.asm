;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;
;	$Id: w_point.asm,v 1.1 2008-07-17 15:39:56 stefano Exp $
;


;Usage: point(struct *pixel)
;Result is true/false


                XLIB    point

                LIB     w_pointxy
                LIB     swapgfxbk
                LIB     swapgfxbk1


.point
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
