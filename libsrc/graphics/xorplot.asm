;
;       Z88DK Graphics Functions - Small C+ stubs
;
;	$Id: xorplot.asm,v 1.4 2016-04-13 20:16:59 dom Exp $
;

;Usage: xorplot(struct *pixel)


                PUBLIC    xorplot
                PUBLIC    _xorplot
                EXTERN     swapgfxbk
                EXTERN     __graphics_end

                EXTERN     xorpixel

.xorplot
._xorplot
		push	ix
		ld	ix,2
		add	ix,sp
		ld	l,(ix+2)
		ld	h,(ix+4)
                call    swapgfxbk
                call    xorpixel
                jp      __graphics_end

