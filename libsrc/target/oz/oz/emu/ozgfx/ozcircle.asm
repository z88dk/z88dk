;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	void ozcircle(int x,int y,byte r,byte color);
;
; ------
; $Id: ozcircle.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

	SECTION code_clib
	PUBLIC	ozcircle
	PUBLIC	_ozcircle

        EXTERN     swapgfxbk
        EXTERN     __oz_gfxend

	EXTERN     draw_circle
        EXTERN     ozplotpixel
        
        EXTERN	ozpointcolor



.ozcircle
._ozcircle
		push	ix	;save callers
		ld	ix,2
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
                jp      __oz_gfxend

.filloop
		push	bc
		push	de
		call    draw_circle
		pop	de
		pop	bc
		dec	d
		jr	nz,filloop
		jp	__oz_gfxend
		
