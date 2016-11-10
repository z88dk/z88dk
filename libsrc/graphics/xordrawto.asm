;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: xordrawto.asm,v 1.1 2016-11-10 07:34:56 stefano Exp $
;


;Usage: xordrawto(struct *pixels)


                SECTION         code_clib
                PUBLIC    xordrawto
                PUBLIC    _xordrawto
                EXTERN     swapgfxbk
                EXTERN	__graphics_end

				EXTERN	__gfx_coords

                EXTERN     Line
                EXTERN     xorpixel



.xordrawto
._xordrawto
		push	ix
		ld	ix,2
		add	ix,sp
		ld	hl,(__gfx_coords)
		ld	e,(ix+2)	;y
		ld	d,(ix+4)	;x

                call    swapgfxbk
                ld      ix,xorpixel
                call    Line
                jp      __graphics_end

