;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: unplot.asm,v 1.3 2001-04-18 13:21:38 stefano Exp $
;


;Usage: plot(struct *pixel)



                XLIB    unplot
                LIB     swapgfxbk

                LIB     respixel



.unplot
		ld	ix,0
		add	ix,sp
		ld	l,(ix+2)
		ld	h,(ix+4)
                call    swapgfxbk
                call    respixel
                jp      swapgfxbk

