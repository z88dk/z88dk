;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: clga.asm,v 1.4 2002-04-03 10:56:52 stefano Exp $
;


;Usage: clga(struct *pixels)



                XLIB    clga
                LIB     swapgfxbk
		XREF	swapgfxbk1
                LIB     cleararea


.clga
		ld	ix,0
		add	ix,sp
		ld	c,(ix+2)
		ld	b,(ix+4)
		ld	l,(ix+6)
		ld	h,(ix+8)
                call    swapgfxbk
                call    cleararea
                jp      swapgfxbk1

