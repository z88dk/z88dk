;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: w_xordrawto.asm,v 1.1 2016-11-10 07:34:55 stefano Exp $
;


;Usage: xordrawto(struct *pixels)


        SECTION code_clib
                PUBLIC    xordrawto
                PUBLIC    _xordrawto
                EXTERN     swapgfxbk
                EXTERN	__graphics_end

                EXTERN     w_line
                EXTERN     w_xorpixel


.xordrawto
._xordrawto
		push	ix
		ld	ix,4
		add	ix,sp
		ld	l,(ix+2)
		ld	h,(ix+3)
		ld	e,(ix+0)
		ld	d,(ix+1)
                call    swapgfxbk
                ld      ix,w_xorpixel
                call    w_line
                jp      __graphics_end

