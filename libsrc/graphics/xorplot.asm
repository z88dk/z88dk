;
;       Z88DK Graphics Functions - Small C+ stubs
;
;	$Id: xorplot.asm,v 1.2 2008-06-30 16:43:00 stefano Exp $
;

;Usage: xorplot(struct *pixel)


                XLIB    xorplot
                LIB     swapgfxbk
                XREF     swapgfxbk1

                LIB     xorpixel

.xorplot
		ld	ix,0
		add	ix,sp
		ld	l,(ix+2)
		ld	h,(ix+4)
                call    swapgfxbk
                call    xorpixel
                jp      swapgfxbk1

