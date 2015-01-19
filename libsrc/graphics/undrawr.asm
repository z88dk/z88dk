;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: undrawr.asm,v 1.5 2015-01-19 01:32:46 pauloscustodio Exp $
;


;Usage: undrawr(struct *pixels)



                PUBLIC    undrawr
                EXTERN     swapgfxbk
                EXTERN	swapgfxbk1


                EXTERN     Line_r
                EXTERN     respixel



.undrawr
		ld	ix,0
		add	ix,sp
		ld	e,(ix+2)
		ld	d,(ix+3)
		ld	l,(ix+4)
		ld	h,(ix+5)
                ld      ix,respixel
                call    swapgfxbk
                call    Line_r
                jp      swapgfxbk1

