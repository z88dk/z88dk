;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: w_uncircle.asm,v 1.1 2010-11-22 18:25:52 stefano Exp $
;


;Usage: uncircle(struct *pixels)

	XLIB    uncircle
	LIB     w_draw_circle
	LIB     w_respixel
	LIB     swapgfxbk
	XREF	swapgfxbk1


.uncircle
		ld ix,0
		add ix,sp

;       de = x0, hl = y0, bc = radius, a = scale factor

		ld a,(ix+2)	;skip
		ld c,(ix+4)	;radius
		ld b,(ix+5)
		ld l,(ix+6)	;y
		ld h,(ix+7)
		ld e,(ix+8)	;x
		ld d,(ix+9)
		ld ix,w_respixel
		call swapgfxbk
		call w_draw_circle
		jp swapgfxbk1

