;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: unplot.asm,v 1.5 2015-01-19 01:32:46 pauloscustodio Exp $
;


;Usage: unplot(struct *pixel)



                PUBLIC    unplot
                EXTERN     swapgfxbk
                EXTERN    swapgfxbk1

                EXTERN     respixel



.unplot
		ld	ix,0
		add	ix,sp
		ld	l,(ix+2)
		ld	h,(ix+4)
                call    swapgfxbk
                call    respixel
                jp      swapgfxbk1

