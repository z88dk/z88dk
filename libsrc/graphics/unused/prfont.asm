;
;	Print using 8x8 font to the Map
;
;
;	$Id: prfont.asm,v 1.3 2016-07-14 17:44:17 pauloscustodio Exp $
;


		PUBLIC	mapchar

		EXTERN	swapgfxbk

		EXTERN	base_graphics

;Dump an 8x8 character to the screen
;Entry:	hl=character address
;	 d=y
;	 e=x

;Each map row consists of 256 bytes, each character is unique so can just
;copy..

.mapchar
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
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi
		call	swapgfxbk
		ret

		

		

