;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	void ozline(int x,int y,int x2,int y2,byte color);
;
; ------
; $Id: ozline.asm,v 1.1 2003-10-27 16:56:57 stefano Exp $
;

	XLIB	ozline

        LIB     swapgfxbk
        LIB     swapgfxbk1

	LIB     line
        LIB     ozplotpixel
        
        LIB	ozpointcolor


.ozline
		ld	ix,0
		add	ix,sp
		call	ozpointcolor

		ld	l,(ix+8)	;y0
		ld	h,(ix+10)	;x0
		ld	e,(ix+4)	;y1
		ld	d,(ix+6)	;x1
		call    swapgfxbk
		push	hl
		push    de
		call	ozplotpixel
		pop     de
		pop	hl
                ld      ix,ozplotpixel
                call    line
                jp      swapgfxbk1
