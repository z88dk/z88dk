;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: w_undrawto.asm,v 1.4 2016-04-23 20:37:40 dom Exp $
;


;Usage: undrawto(struct *pixels)


	SECTION   code_clib
                PUBLIC    undrawto
                PUBLIC    _undrawto
                EXTERN     swapgfxbk
                EXTERN	__graphics_end

                EXTERN     w_line
                EXTERN     w_respixel


.undrawto
._undrawto
		push	ix
		ld	ix,4
		add	ix,sp
		ld	l,(ix+2)
		ld	h,(ix+3)
		ld	e,(ix+0)
		ld	d,(ix+1)
                call    swapgfxbk
                ld      ix,w_respixel
                call    w_line
                jp      __graphics_end

