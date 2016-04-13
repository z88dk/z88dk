;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: plot.asm,v 1.8 2016-04-13 21:09:09 dom Exp $
;

;Usage: plot(struct *pixel)



        SECTION code_clib
                PUBLIC    plot
                PUBLIC    _plot
                EXTERN     swapgfxbk
                EXTERN    __graphics_end

                EXTERN     plotpixel

.plot
._plot
		push	ix
		ld	ix,2
		add	ix,sp
		ld	l,(ix+2)
		ld	h,(ix+4)
                call    swapgfxbk
                call    plotpixel
                jp      __graphics_end

