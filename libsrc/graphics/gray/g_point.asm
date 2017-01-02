;
;       TI Gray Library Functions
;
;       Written by Stefano Bodrato - Mar 2001
;
;
;	$Id: g_point.asm,v 1.4 2017-01-02 22:57:58 aralbrec Exp $
;

;Usage: g_point(int px, int py)


                PUBLIC    g_point
                PUBLIC    _g_point

                EXTERN     pointxy
		EXTERN	graypage


.g_point
._g_point
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

