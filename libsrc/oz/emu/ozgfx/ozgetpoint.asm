;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	int ozgetpoint(int x, int y);
;
; ------
; $Id: ozgetpoint.asm,v 1.1 2003-10-29 11:37:11 stefano Exp $
;

	XLIB	ozgetpoint

        LIB     pointxy
        LIB     swapgfxbk


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

