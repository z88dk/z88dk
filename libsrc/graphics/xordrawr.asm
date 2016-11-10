;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: xordrawr.asm,v 1.1 2016-11-10 07:34:55 stefano Exp $
;


;Usage: xordrawr(struct *pixels)


                SECTION         code_clib
                PUBLIC    xordrawr
                PUBLIC    _xordrawr
                EXTERN     swapgfxbk
                EXTERN        __graphics_end

                EXTERN     Line_r
                EXTERN     xorpixel



.xordrawr
._xordrawr
		push	ix
		ld	ix,2
		add	ix,sp
		ld	e,(ix+2)	;py
		ld	d,(ix+3)
		ld	l,(ix+4)	;px
		ld	h,(ix+5)

                call    swapgfxbk
                ld      ix,xorpixel
                call    Line_r
                jp      __graphics_end

