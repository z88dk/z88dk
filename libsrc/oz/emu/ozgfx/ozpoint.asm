;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	int ozpoint(int x, int y, byte color);
;
; ------
; $Id: ozpoint.asm,v 1.1 2003-10-27 16:56:57 stefano Exp $
;

	XLIB	ozpoint

        LIB     swapgfxbk
        LIB     swapgfxbk1

        LIB     ozplotpixel
        
        LIB	ozpointcolor



.ozpoint
		ld	ix,0
		add	ix,sp
		call	ozpointcolor

		ld	l,(ix+4)
		ld	h,(ix+6)
                call    swapgfxbk
                call    ozplotpixel
                jp      swapgfxbk1
