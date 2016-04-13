;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: drawr.asm,v 1.8 2016-04-13 21:09:09 dom Exp $
;


;Usage: drawr(struct *pixels)


                SECTION         code_clib
                PUBLIC    drawr
                PUBLIC    _drawr
                EXTERN     swapgfxbk
                EXTERN        __graphics_end

                EXTERN     Line_r
                EXTERN     plotpixel



.drawr
._drawr
		push	ix
		ld	ix,2
		add	ix,sp
		ld	e,(ix+2)	;py
		ld	d,(ix+3)
		ld	l,(ix+4)	;px
		ld	h,(ix+5)

                call    swapgfxbk
                ld      ix,plotpixel
                call    Line_r
                jp      __graphics_end

