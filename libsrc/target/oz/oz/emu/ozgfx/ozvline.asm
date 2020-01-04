;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	void ozvline(byte x,byte y,byte len,byte color)
;
; ------
; $Id: ozvline.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

	SECTION code_clib
	PUBLIC	ozvline
	PUBLIC	_ozvline

        EXTERN     swapgfxbk
        EXTERN     __oz_gfxend

	EXTERN     line
        EXTERN     ozplotpixel
        
        EXTERN	ozpointcolor


.ozvline
._ozvline
		push	ix
		ld	ix,2
		add	ix,sp
		call	ozpointcolor

		ld	l,(ix+6)	;y0
		ld	h,(ix+8)	;x0

		ld	e,h		;x1
		ld	a,(ix+4)
		add	l
		ld	d,a		;y1 (y0 + len)

		call    swapgfxbk
		push	hl
		push    de
		call	ozplotpixel
		pop     de
		pop	hl
                ld      ix,ozplotpixel
                call    line
                jp      __oz_gfxend
