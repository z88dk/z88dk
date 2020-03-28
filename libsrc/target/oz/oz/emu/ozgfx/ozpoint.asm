;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	int ozpoint(int x, int y, byte color);
;
; ------
; $Id: ozpoint.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

	SECTION code_clib
	PUBLIC	ozpoint
	PUBLIC	_ozpoint

        EXTERN     swapgfxbk
        EXTERN     __oz_gfxend

        EXTERN     ozplotpixel
        
        EXTERN	ozpointcolor



.ozpoint
._ozpoint
		push	ix	;save callers
		ld	ix,2
		add	ix,sp
		call	ozpointcolor

		ld	l,(ix+4)
		ld	h,(ix+6)
                call    swapgfxbk
                call    ozplotpixel
                jp      __oz_gfxend
