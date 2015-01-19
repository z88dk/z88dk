;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: undraw.asm,v 1.5 2015-01-19 01:32:46 pauloscustodio Exp $
;



                PUBLIC    undraw
                EXTERN     swapgfxbk
                EXTERN	swapgfxbk1

                EXTERN     Line
                EXTERN     respixel



.undraw
		ld	ix,0
		add	ix,sp
		ld	e,(ix+2)	;y1
		ld	d,(ix+4)	;x1
		ld	l,(ix+6)	;y0
		ld	h,(ix+8)	;x0
                ld      ix,respixel
                call    swapgfxbk
                call    Line
                jp      swapgfxbk1

