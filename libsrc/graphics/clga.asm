;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: clga.asm,v 1.5 2015-01-19 01:32:46 pauloscustodio Exp $
;


;Usage: clga(struct *pixels)



                PUBLIC    clga
                EXTERN     swapgfxbk
		EXTERN	swapgfxbk1
                EXTERN     cleararea


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

