;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: undrawr.asm,v 1.7 2016-04-13 21:09:09 dom Exp $
;


;Usage: undrawr(struct *pixels)



        SECTION code_clib
                PUBLIC    undrawr
                PUBLIC    _undrawr
                EXTERN     swapgfxbk
                EXTERN	__graphics_end


                EXTERN     Line_r
                EXTERN     respixel



.undrawr
._undrawr
		push	ix
		ld	ix,2
		add	ix,sp
		ld	e,(ix+2)
		ld	d,(ix+3)
		ld	l,(ix+4)
		ld	h,(ix+5)
                ld      ix,respixel
                call    swapgfxbk
                call    Line_r
                jp      __graphics_end

