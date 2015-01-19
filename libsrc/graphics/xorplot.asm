;
;       Z88DK Graphics Functions - Small C+ stubs
;
;	$Id: xorplot.asm,v 1.3 2015-01-19 01:32:47 pauloscustodio Exp $
;

;Usage: xorplot(struct *pixel)


                PUBLIC    xorplot
                EXTERN     swapgfxbk
                EXTERN     swapgfxbk1

                EXTERN     xorpixel

.xorplot
		ld	ix,0
		add	ix,sp
		ld	l,(ix+2)
		ld	h,(ix+4)
                call    swapgfxbk
                call    xorpixel
                jp      swapgfxbk1

