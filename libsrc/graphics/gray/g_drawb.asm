;
;       TI Gray Library Functions
;
;       Written by Stefano Bodrato - Mar 2001
;
;

;Usage: g_drawb(int tlx, int tly, int width, int height, int GrayLevel);


                XLIB    g_drawb

                XREF    base_graphics
		XREF	graybit1
		XREF	graybit2

                LIB     drawbox
                LIB     plotpixel
                LIB     respixel


.g_drawb
		ld	ix,0
		add	ix,sp
		ld	a,(ix+2)	;GrayLevel
		ld	b,(ix+4)	;H
		ld	c,(ix+6)	;W
		ld	l,(ix+8)	;y
		ld	h,(ix+10)	;x
		
		ld	de,(graybit1)
		ld	(base_graphics),de
                ld	ix,plotpixel
		rra
		jr	c,set1
                ld	ix,respixel
.set1
		push	af
		push	hl
		push	bc
                call	drawbox
                pop	bc
		pop	hl
		pop	af

		ld	de,(graybit2)
		ld	(base_graphics),de

                ld	ix,plotpixel
		rra
		jr	c,set2
                ld	ix,respixel
.set2
                jp	drawbox
