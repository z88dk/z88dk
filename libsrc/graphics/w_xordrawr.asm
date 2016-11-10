;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;
;	$Id: w_xordrawr.asm,v 1.1 2016-11-10 07:34:55 stefano Exp $
;


        SECTION code_clib
                PUBLIC    xordrawr
                PUBLIC    _xordrawr
                EXTERN     swapgfxbk
                EXTERN	__graphics_end

                EXTERN     w_line_r
                EXTERN     w_xorpixel


.xordrawr
._xordrawr
		push	ix
		ld	ix,2
		add	ix,sp
		ld	e,(ix+2)
		ld	d,(ix+3)
		ld	l,(ix+4)
		ld	h,(ix+5)
                call    swapgfxbk
                ld      ix,w_xorpixel
                call    w_line_r
                jp      __graphics_end

