;
;       TI Gray Library Functions
;
;       Written by Stefano Bodrato - Mar 2001
;
;
;	$Id: g_circle.asm,v 1.3 2001-04-18 13:21:38 stefano Exp $
;

;Usage: g_circle(int x, int y, int radius, int skip, int GrayLevel)


                XLIB    g_circle

                LIB     draw_circle
                LIB     plotpixel
                LIB     respixel
                LIB     graypage


.g_circle
		ld	ix,0
		add	ix,sp
		ld	a,(ix+2)	;GrayLevel
		ld	e,(ix+4)	;skip
		ld	d,(ix+6)	;radius
		ld	c,(ix+8)	;y
		ld	b,(ix+10)	;x
		
		push	af
		xor	a
		call	graypage
		pop	af
                ld	ix,plotpixel
		rra
		jr	nc,set1
                ld	ix,respixel
.set1
		push	af
		push	de
		push	bc
                call	draw_circle
                pop	bc
		pop	de
		pop	af

		push	af
		ld	a,1
		call	graypage
		pop	af
                ld	ix,plotpixel
		rra
		jr	nc,set2
                ld	ix,respixel
.set2
                jp	draw_circle
