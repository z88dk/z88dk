;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	int ozpoint(int x, int y, byte color);
;
; ------
; $Id: ozpoint.asm,v 1.2 2015-01-19 01:33:01 pauloscustodio Exp $
;

	PUBLIC	ozpoint

        EXTERN     swapgfxbk
        EXTERN     swapgfxbk1

        EXTERN     ozplotpixel
        
        EXTERN	ozpointcolor



.ozpoint
		ld	ix,0
		add	ix,sp
		call	ozpointcolor

		ld	l,(ix+4)
		ld	h,(ix+6)
                call    swapgfxbk
                call    ozplotpixel
                jp      swapgfxbk1
