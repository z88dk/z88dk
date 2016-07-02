;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: drawto.asm,v 1.8 2016-07-02 09:01:35 dom Exp $
;


;Usage: drawto(struct *pixels)


                SECTION         code_clib
                PUBLIC    drawto
                PUBLIC    _drawto
                EXTERN     swapgfxbk
                EXTERN	__graphics_end

				EXTERN	__gfx_coords

                EXTERN     Line
                EXTERN     plotpixel



.drawto
._drawto
		push	ix
		ld	ix,2
		add	ix,sp
		ld	hl,(__gfx_coords)
		ld	e,(ix+2)	;y
		ld	d,(ix+4)	;x

                call    swapgfxbk
                ld      ix,plotpixel
                call    Line
                jp      __graphics_end

