;
;	Print using 8x8 font to the Map
;
;
;	$Id: sprite.asm,v 1.3 2016-07-14 17:44:17 pauloscustodio Exp $
;


		PUBLIC	sprite

		EXTERN	swapgfxbk

		EXTERN	base_graphics

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
