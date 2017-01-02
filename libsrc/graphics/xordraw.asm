;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: xordraw.asm,v 1.3 2017-01-02 21:51:24 aralbrec Exp $
;


                SECTION         code_clib
                PUBLIC    xordraw
		PUBLIC	  _xordraw
                EXTERN     swapgfxbk
		EXTERN        __graphics_end

                EXTERN     Line
                EXTERN     xorpixel


.xordraw
._xordraw
		push	ix
		ld	ix,2
		add	ix,sp
		ld	l,(ix+6)	;y0
		ld	h,(ix+8)	;x0
		ld	e,(ix+2)	;y1
		ld	d,(ix+4)	;x1
		call    swapgfxbk
		push	hl
		push    de
		call	xorpixel
		pop     de
		pop	hl
                ld      ix,xorpixel
                call    Line
		jp	__graphics_end

