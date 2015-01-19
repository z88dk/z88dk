;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	void ozhline(byte x,byte y,byte len,byte color)
;
; ------
; $Id: ozhline.asm,v 1.3 2015-01-19 01:33:01 pauloscustodio Exp $
;

	PUBLIC	ozhline

        EXTERN	swapgfxbk
        EXTERN	swapgfxbk1

	EXTERN	line
        EXTERN	ozplotpixel
        
        EXTERN	ozpointcolor


.ozhline
		ld	ix,0
		add	ix,sp
		call	ozpointcolor
		
		ld	l,(ix+6)	;y0
		ld	h,(ix+8)	;x0
		
		ld	d,l		;y1
		ld	a,(ix+4)
		add	h
		dec	a
		ld	e,a		;x1 (x0 + len-1)
		
		call    swapgfxbk
		push	hl
		push    de
		call	ozplotpixel
		pop     de
		pop	hl
		ld      ix,ozplotpixel
		call    line
		jp      swapgfxbk1
