;
;       TI Gray Library Functions
;
;       Written by Stefano Bodrato - Mar 2001
;
;
;	$Id: g_point.asm,v 1.2 2001-04-18 13:21:38 stefano Exp $
;

;Usage: g_point(int px, int py)


                XLIB    g_point

                LIB     pointxy
		LIB	graypage


.g_point
		ld	ix,0
		add	ix,sp
		ld	l,(ix+2)
		ld	h,(ix+4)

		xor	a
		call	graypage

		push	hl
                call    pointxy
                pop	hl
                ld	bc,0
                jr	nz,jpover1
                inc	c
.jpover1
		push	bc
		ld	a,1
		call	graypage
                call    pointxy
		pop	hl
                jr	nz,jpover2
                rl	l
                inc	l
.jpover2
                ret

