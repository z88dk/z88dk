;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;
;	$Id: w_drawr.asm,v 1.2 2015-01-19 01:32:46 pauloscustodio Exp $
;


                PUBLIC    drawr
                EXTERN     swapgfxbk
                EXTERN	swapgfxbk1

                EXTERN     w_line_r
                EXTERN     w_plotpixel


.drawr
		ld	ix,0
		add	ix,sp
		ld	e,(ix+2)
		ld	d,(ix+3)
		ld	l,(ix+4)
		ld	h,(ix+5)
                call    swapgfxbk
                ld      ix,w_plotpixel
                call    w_line_r
                jp      swapgfxbk1

