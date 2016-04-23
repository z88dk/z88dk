;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: w_uncircle.asm,v 1.4 2016-04-23 20:37:40 dom Exp $
;


;Usage: uncircle(struct *pixels)

	SECTION   code_clib
	PUBLIC    uncircle
	PUBLIC    _uncircle
	EXTERN     w_draw_circle
	EXTERN     w_respixel
	EXTERN     swapgfxbk
	EXTERN	   __graphics_end


.uncircle
._uncircle
		push	ix
		ld ix,2
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
		jp   __graphics_end

