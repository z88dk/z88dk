;
;       TI Gray Library Functions
;
;       Written by Stefano Bodrato - Mar 2001
;
;

;Usage: g_plot(int x, int y, int GrayLevel)


                XLIB    g_plot

                XREF    base_graphics
		XREF	graybit1
		XREF	graybit2

                LIB     plotpixel
		LIB     respixel

.g_plot
		ld	ix,0
		add	ix,sp
		ld	a,(ix+2)	;GrayLevel
		ld	l,(ix+4)	;y
		ld	h,(ix+6)	;x
		
		ld	de,(graybit1)
		ld	(base_graphics),de
		rra
		jr	c,set1
		push	af
		push	hl
		call	respixel
		pop	hl
		pop	af
		jr	page2
.set1
		push	af
		push	hl
		call	plotpixel
		pop	hl
		pop	af

.page2
		ld	de,(graybit2)
		ld	(base_graphics),de
		rra
		jp	c,plotpixel
		jp	respixel
