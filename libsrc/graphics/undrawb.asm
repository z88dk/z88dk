;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: undrawb.asm,v 1.6 2016-04-13 21:09:09 dom Exp $
;



        SECTION code_graphics
                PUBLIC    undrawb
                PUBLIC    _undrawb

                EXTERN     drawbox
                EXTERN     respixel
                EXTERN     swapgfxbk
                EXTERN	__graphics_end


.undrawb
._undrawb
		push	ix
		ld	ix,2
		add	ix,sp
		ld	c,(ix+2)
		ld	b,(ix+4)
		ld	l,(ix+6)
		ld	h,(ix+8)
                ld      ix,respixel
                call    swapgfxbk
                call    drawbox
                jp      __graphics_end

