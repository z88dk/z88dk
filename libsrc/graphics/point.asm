;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: point.asm,v 1.3 2001-04-18 13:21:37 stefano Exp $
;


;Usage: point(struct *pixel)
;Result is true/false


                XLIB    point

                LIB     pointxy
                LIB     swapgfxbk



.point
		ld	ix,0
		add	ix,sp
		ld	l,(ix+2)
		ld	h,(ix+4)
                call    swapgfxbk
                call    pointxy
                ex      af,af'
                call    swapgfxbk
                ex      af,af'
                ld      hl,1
                ret     z       ;pixel set
                dec     hl
                ret

