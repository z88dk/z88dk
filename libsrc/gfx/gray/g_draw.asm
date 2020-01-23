;
;       TI Gray Library Functions
;
;       Written by Stefano Bodrato - Mar 2001
;
;
;	$Id: g_draw.asm,v 1.6 2017-01-02 22:57:58 aralbrec Exp $
;

;Usage: g_draw(int x1, int y1, int x2, int y2, int GrayLevel)


                PUBLIC    g_draw
                PUBLIC    _g_draw

                EXTERN     Line
                EXTERN     plotpixel
                EXTERN     respixel
                EXTERN	graypage


.g_draw
._g_draw
		ld	ix,0
		add	ix,sp
		ld	a,(ix+2)	;GrayLevel
		ld	e,(ix+4)	;y1
		ld	d,(ix+6)	;x1
		ld	l,(ix+8)	;y0
		ld	h,(ix+10)	;x0
		
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
		push	hl
		push	de
                call	Line
                pop	de
		pop	hl
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
                jp	Line
