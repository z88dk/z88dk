;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;
;	$Id: w_undraw.asm,v 1.5 2016-04-23 20:37:40 dom Exp $
;


	SECTION   code_clib
                PUBLIC    undraw
                PUBLIC   _undraw
                EXTERN     swapgfxbk
                EXTERN     swapgfxbk1
                EXTERN __graphics_end

                EXTERN     w_line
                EXTERN     w_respixel


.undraw
._undraw
		push	ix
		ld	ix,4
		add	ix,sp
		ld	l,(ix+6)
		ld	h,(ix+7)
		ld	e,(ix+4)
		ld	d,(ix+5)

		call    swapgfxbk
		call	w_respixel
                call    swapgfxbk1

		ld	l,(ix+2)
		ld	h,(ix+3)
		ld	e,(ix+0)
		ld	d,(ix+1)

		call    swapgfxbk
                ld      ix,w_respixel
                call    w_line
                jp      __graphics_end
