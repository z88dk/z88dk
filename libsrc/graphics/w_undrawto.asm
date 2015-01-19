;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: w_undrawto.asm,v 1.2 2015-01-19 01:32:46 pauloscustodio Exp $
;


;Usage: undrawto(struct *pixels)


                PUBLIC    undrawto
                EXTERN     swapgfxbk
                EXTERN	swapgfxbk1

                EXTERN     w_line
                EXTERN     w_respixel


.undrawto
		ld	ix,2
		add	ix,sp
		ld	l,(ix+2)
		ld	h,(ix+3)
		ld	e,(ix+0)
		ld	d,(ix+1)
                call    swapgfxbk
                ld      ix,w_respixel
                call    w_line
                jp      swapgfxbk1

