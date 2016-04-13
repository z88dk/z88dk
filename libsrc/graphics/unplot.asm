;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: unplot.asm,v 1.7 2016-04-13 21:09:09 dom Exp $
;


;Usage: unplot(struct *pixel)



        SECTION code_clib
                PUBLIC    unplot
                PUBLIC    _unplot
                EXTERN     swapgfxbk
                EXTERN    __graphics_end

                EXTERN     respixel



.unplot
._unplot
		push	ix
		ld	ix,2
		add	ix,sp
		ld	l,(ix+2)
		ld	h,(ix+4)
                call    swapgfxbk
                call    respixel
                jp      __graphics_end

