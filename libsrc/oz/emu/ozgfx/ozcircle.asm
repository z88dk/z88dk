;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	void ozcircle(int x,int y,byte r,byte color);
;
; ------
; $Id: ozcircle.asm,v 1.1 2003-10-27 16:56:57 stefano Exp $
;

	XLIB	ozcircle

        LIB     swapgfxbk
        LIB     swapgfxbk1

	LIB     draw_circle
        LIB     ozplotpixel
        
        LIB	ozpointcolor



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
		