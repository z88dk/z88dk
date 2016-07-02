;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: undrawto.asm,v 1.8 2016-07-02 09:01:35 dom Exp $
;


;Usage: undrawto(struct *pixels)


        SECTION code_clib
                PUBLIC    undrawto
                PUBLIC    _undrawto
                EXTERN     swapgfxbk
                EXTERN	__graphics_end

				EXTERN	__gfx_coords

                EXTERN     Line
                EXTERN     respixel



.undrawto
._undrawto
		push	ix
		ld	ix,2
		add	ix,sp
		ld	hl,(__gfx_coords)
		ld	e,(ix+2)	;y
		ld	d,(ix+4)	;x

                call    swapgfxbk
                ld      ix,respixel
                call    Line
                jp      __graphics_end

