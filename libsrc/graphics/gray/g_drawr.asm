;
;       TI Gray Library Functions
;
;       Written by Stefano Bodrato - Mar 2001
;
;

;Usage: g_drawr(int px, int py, int GrayLevel)


                XLIB    g_drawr

                XREF    base_graphics
		XREF	graybit1
		XREF	graybit2

                LIB     line_r
                LIB     plotpixel
                LIB     respixel


.g_drawr
		ld	ix,0
		add	ix,sp
		ld	a,(ix+2)	;GrayLevel
		ld	e,(ix+4)	;py
		ld	d,(ix+5)
		ld	l,(ix+6)	;px
		ld	h,(ix+7)

		ld	bc,(graybit1)
		ld	(base_graphics),bc
                ld	ix,plotpixel
		rra
		jr	c,set1
                ld	ix,respixel
.set1
		push	af
		push	hl
		push	de
                call	line_r
                pop	de
		pop	hl
		pop	af

		ld	bc,(graybit2)
		ld	(base_graphics),bc
		
                ld	ix,plotpixel
		rra
		jr	c,set2
                ld	ix,respixel
.set2
                jp	line_r
