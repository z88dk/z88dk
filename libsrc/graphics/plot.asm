;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: plot.asm,v 1.4 2001-04-18 13:21:37 stefano Exp $
;

;Usage: plot(struct *pixel)



                XLIB    plot
                LIB     swapgfxbk
                LIB     swapgfxbk1

                LIB     plotpixel

.plot
		ld	ix,0
		add	ix,sp
		ld	l,(ix+2)
		ld	h,(ix+4)
                call    swapgfxbk
                call    plotpixel
                jp      swapgfxbk1

