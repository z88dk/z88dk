;
;	Print using 8x8 font to the Map
;
;
;	$Id: sprite.asm,v 1.2 2001-04-18 13:21:38 stefano Exp $
;


		XLIB	sprite

		LIB	swapgfxbk

		XREF	base_graphics

;Print a 16x16 sprite to the screen - sprites stored as characters..
;Entry:	hl=sprite address
;	 d=y
;	 e=x

;Each map row consists of 256 bytes, each character is unique so can just
;copy..


.sprite
		call	swapgfxbk
		ex	de,hl
		ld	a,l
		sla	a
		sla	a
		sla	a
		ld	l,a
		ld	bc,(base_graphics)
		add	hl,bc
		ex	de,hl
;hl=sprite, de=map address
		ld	bc,16
		ldir
		ex	de,hl
		ld	bc,256-16
		add	hl,bc
		ex	de,hl
		ld	bc,16
		ldir
		call	swapgfxbk
		ret
