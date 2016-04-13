;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;
;	$Id: w_drawr.asm,v 1.4 2016-04-13 21:09:09 dom Exp $
;


        SECTION code_clib
                PUBLIC    drawr
                PUBLIC    _drawr
                EXTERN     swapgfxbk
                EXTERN	__graphics_end

                EXTERN     w_line_r
                EXTERN     w_plotpixel


.drawr
._drawr
		push	ix
		ld	ix,2
		add	ix,sp
		ld	e,(ix+2)
		ld	d,(ix+3)
		ld	l,(ix+4)
		ld	h,(ix+5)
                call    swapgfxbk
                ld      ix,w_plotpixel
                call    w_line_r
                jp      __graphics_end

