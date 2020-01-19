

	SECTION	code_graphics

	PUBLIC	drawto
	PUBLIC	_drawto

	EXTERN commondrawto
	EXTERN plot

;void  drawto(int x2, int y2) __smallc
;Note ints are actually uint8_t
drawto:
_drawto:
	ld	hl,plot
	jp	commondrawto
