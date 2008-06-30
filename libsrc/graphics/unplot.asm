;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: unplot.asm,v 1.4 2008-06-30 16:43:00 stefano Exp $
;


;Usage: unplot(struct *pixel)



                XLIB    unplot
                LIB     swapgfxbk
                XREF    swapgfxbk1

                LIB     respixel



.unplot
		ld	ix,0
		add	ix,sp
		ld	l,(ix+2)
		ld	h,(ix+4)
                call    swapgfxbk
                call    respixel
                jp      swapgfxbk1

