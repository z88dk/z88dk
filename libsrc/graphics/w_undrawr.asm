;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;
;	$Id: w_undrawr.asm,v 1.5 2016-04-23 20:37:40 dom Exp $
;


	SECTION   code_clib
                PUBLIC    undrawr
                PUBLIC    _undrawr
                EXTERN     swapgfxbk
                EXTERN __graphics_end

                EXTERN     w_line_r
                EXTERN     w_respixel


.undrawr
._undrawr
		push	ix
		ld	ix,2
		add	ix,sp
		ld	e,(ix+2)
		ld	d,(ix+3)
		ld	l,(ix+4)
		ld	h,(ix+5)
                call    swapgfxbk
                ld      ix,w_respixel
                call    w_line_r
                jp      __graphics_end

