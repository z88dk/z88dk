;
;	Print using 8x8 font to the Map
;


		XLIB	mapchar

		LIB	swapgfxbk

		XREF	base_graphics

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

		

		

