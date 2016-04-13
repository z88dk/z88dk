;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: clga.asm,v 1.7 2016-04-13 21:09:09 dom Exp $
;


;Usage: clga(struct *pixels)



                SECTION         code_clib
                PUBLIC    clga
                PUBLIC    _clga
                EXTERN     swapgfxbk
		EXTERN	  __graphics_end
                EXTERN     cleararea


.clga
._clga
		push	ix
		ld	ix,2
		add	ix,sp
		ld	c,(ix+2)
		ld	b,(ix+4)
		ld	l,(ix+6)
		ld	h,(ix+8)
                call    swapgfxbk
                call    cleararea
                jp      __graphics_end

