;
;       TI Gray Library Functions
;
;       Written by Stefano Bodrato - Mar 2001
;
;
;	$Id: g_drawb.asm,v 1.5 2017-01-02 22:57:58 aralbrec Exp $
;

;Usage: g_drawb(int tlx, int tly, int width, int height, int GrayLevel);


                PUBLIC    g_drawb
                PUBLIC    _g_drawb

                EXTERN     drawbox
                EXTERN     plotpixel
                EXTERN     respixel
                EXTERN	graypage


.g_drawb
._g_drawb
		ld	ix,0
		add	ix,sp
		ld	a,(ix+2)	;GrayLevel
		ld	b,(ix+4)	;H
		ld	c,(ix+6)	;W
		ld	l,(ix+8)	;y
		ld	h,(ix+10)	;x
		
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
		push	bc
                call	drawbox
                pop	bc
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
                jp	drawbox
