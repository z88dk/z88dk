;
;       Z88DK Graphics Functions - Small C+ stubs
;
;	$Id: xorplot.asm,v 1.1 2002-03-28 09:41:14 stefano Exp $
;

;Usage: xorplot(struct *pixel)


                XLIB    xorplot
                LIB     swapgfxbk
                LIB     swapgfxbk1

                LIB     xorpixel

.xorplot
		ld	ix,0
		add	ix,sp
		ld	l,(ix+2)
		ld	h,(ix+4)
                call    swapgfxbk
                call    xorpixel
                jp      swapgfxbk1

