;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	int ozgetpoint(int x, int y);
;
; ------
; $Id: ozgetpoint.asm,v 1.2 2015-01-19 01:33:01 pauloscustodio Exp $
;

	PUBLIC	ozgetpoint

        EXTERN     pointxy
        EXTERN     swapgfxbk


.ozgetpoint
		ld	ix,0
		add	ix,sp
		ld	l,(ix+2)
		ld	h,(ix+4)
                call    swapgfxbk
                call    pointxy
                ex      af,af'
                call    swapgfxbk
                ex      af,af'
                ld      hl,0
                ret     z       ;pixel set
                inc     hl
                ret

