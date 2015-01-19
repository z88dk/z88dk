;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	void ozcircle(int x,int y,byte r,byte color);
;
; ------
; $Id: ozcircle.asm,v 1.2 2015-01-19 01:33:01 pauloscustodio Exp $
;

	PUBLIC	ozcircle

        EXTERN     swapgfxbk
        EXTERN     swapgfxbk1

	EXTERN     draw_circle
        EXTERN     ozplotpixel
        
        EXTERN	ozpointcolor



.ozcircle
		ld	ix,0
		add	ix,sp
		ld	a,(ix+2)
		and	4
		push	af
		call	ozpointcolor

		ld	e,1		;skip
		ld	d,(ix+4)	;radius
		ld	c,(ix+6)	;y
		ld	b,(ix+8)	;x
                ld      ix,ozplotpixel
                call    swapgfxbk
		pop	af
		jr	nz,filloop
                call    draw_circle
                jp      swapgfxbk1

.filloop
		push	bc
		push	de
		call    draw_circle
		pop	de
		pop	bc
		dec	d
		jr	nz,filloop
		jp	swapgfxbk1
		