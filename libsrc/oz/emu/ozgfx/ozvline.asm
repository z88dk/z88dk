;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	void ozvline(byte x,byte y,byte len,byte color)
;
; ------
; $Id: ozvline.asm,v 1.1 2003-10-27 16:56:57 stefano Exp $
;

	XLIB	ozvline

        LIB     swapgfxbk
        LIB     swapgfxbk1

	LIB     line
        LIB     ozplotpixel
        
        LIB	ozpointcolor


.ozvline
		ld	ix,0
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
                jp      swapgfxbk1
