;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	void ozhline(byte x,byte y,byte len,byte color)
;
; ------
; $Id: ozhline.asm,v 1.4 2016-06-28 14:48:17 dom Exp $
;

	SECTION code_clib
	PUBLIC	ozhline
	PUBLIC	_ozhline

        EXTERN	swapgfxbk
        EXTERN	__oz_gfxend

	EXTERN	line
        EXTERN	ozplotpixel
        
        EXTERN	ozpointcolor


.ozhline
._ozhline
		push	ix	;save callers
		ld	ix,2
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
		jp      __oz_gfxend
