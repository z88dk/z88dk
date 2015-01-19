;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	void ozbox(int x, int y, int width, int height);
;
; ------
; $Id: ozbox.asm,v 1.2 2015-01-19 01:33:01 pauloscustodio Exp $
;

	PUBLIC	ozbox

        EXTERN     swapgfxbk
        EXTERN     swapgfxbk1

        EXTERN     drawbox
        EXTERN     plotpixel	; yes, this costs some byte, but I preferred to
        			; leave ozpointcolor and ozplotpixel as they are.



.ozbox
		ld	ix,0
		add	ix,sp
		ld	c,(ix+8)
		ld	b,(ix+6)
		ld	l,(ix+4)
		ld	h,(ix+2)
                ld      ix,plotpixel
                call    swapgfxbk
                call    drawbox
                jp      swapgfxbk1
