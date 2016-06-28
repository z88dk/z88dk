;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	void ozbox(int x, int y, int width, int height);
;
; ------
; $Id: ozbox.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozbox
	PUBLIC	_ozbox

        EXTERN     swapgfxbk
        EXTERN     swapgfxbk1
	EXTERN	   __oz_gfxend

        EXTERN     drawbox
        EXTERN     plotpixel	; yes, this costs some byte, but I preferred to
        			; leave ozpointcolor and ozplotpixel as they are.



.ozbox
._ozbox
		push	ix
		ld	ix,2
		add	ix,sp
		ld	c,(ix+8)
		ld	b,(ix+6)
		ld	l,(ix+4)
		ld	h,(ix+2)
                ld      ix,plotpixel
                call    swapgfxbk
                call    drawbox
		jp	__oz_gfxend
