;
;       TI Gray Library Functions
;
;       Written by Stefano Bodrato - Mar 2001
;
;
;	$Id: g_drawr.asm,v 1.8 2017-01-02 22:57:58 aralbrec Exp $
;

;Usage: g_drawr(int px, int py, int GrayLevel)

                PUBLIC    g_drawr
                PUBLIC    _g_drawr

		EXTERN	__gfx_coords

                EXTERN     Line_r
                EXTERN     plotpixel
                EXTERN     respixel
                EXTERN     graypage


.g_drawr
._g_drawr
		ld	ix,0
		add	ix,sp
		ld	a,(ix+2)	;GrayLevel
		ld	e,(ix+4)	;py
		ld	d,(ix+5)
		ld	l,(ix+6)	;px
		ld	h,(ix+7)

		ld	bc,(__gfx_coords)
		push	bc
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
                call	Line_r
                pop	de
		pop	hl
		pop	af

		pop	bc
		ld	(__gfx_coords),bc
		push	af
		ld	a,1
		call	graypage
		pop	af
		
                ld	ix,plotpixel
		rra
		jr	nc,set2
                ld	ix,respixel
.set2
                jp	Line_r
