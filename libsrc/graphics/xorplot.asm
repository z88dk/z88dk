;
;       Z88DK Graphics Functions - Small C+ stubs
;
;	$Id: xorplot.asm,v 1.5 2016-04-22 20:17:17 dom Exp $
;

;Usage: xorplot(struct *pixel)

		SECTION	  code_clib
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

