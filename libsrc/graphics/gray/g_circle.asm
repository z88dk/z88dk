;
;       TI Gray Library Functions
;
;       Written by Stefano Bodrato - Mar 2001
;
;

;Usage: g_circle(int x, int y, int radius, int skip, int GrayLevel)


                XLIB    g_circle

                XREF    base_graphics
		XREF	graybit1
		XREF	graybit2

                LIB     draw_circle
                LIB     plotpixel
                LIB     respixel


.g_circle
		ld	ix,0
		add	ix,sp
		ld	a,(ix+2)	;GrayLevel
		ld	e,(ix+4)	;skip
		ld	d,(ix+6)	;radius
		ld	c,(ix+8)	;y
		ld	b,(ix+10)	;x
		
		ld	hl,(graybit1)
		ld	(base_graphics),hl
                ld	ix,plotpixel
		rra
		jr	c,set1
                ld	ix,respixel
.set1
		push	af
		push	de
		push	bc
                call	draw_circle
                pop	bc
		pop	de
		pop	af

		ld	hl,(graybit2)
		ld	(base_graphics),hl
                ld	ix,plotpixel
		rra
		jr	c,set2
                ld	ix,respixel
.set2
                jp	draw_circle
