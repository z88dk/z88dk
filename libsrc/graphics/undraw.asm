;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: undraw.asm,v 1.7 2016-04-13 21:09:09 dom Exp $
;



        SECTION code_clib
                PUBLIC    undraw
                PUBLIC    _undraw
                EXTERN     swapgfxbk
                EXTERN	__graphics_end

                EXTERN     Line
                EXTERN     respixel



.undraw
._undraw
		push	ix
		ld	ix,2
		add	ix,sp
		ld	e,(ix+2)	;y1
		ld	d,(ix+4)	;x1
		ld	l,(ix+6)	;y0
		ld	h,(ix+8)	;x0
                ld      ix,respixel
                call    swapgfxbk
                call    Line
                jp      __graphics_end

