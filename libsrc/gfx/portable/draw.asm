

	SECTION	code_graphics

	PUBLIC	draw
	PUBLIC	_draw

	EXTERN commondraw
	EXTERN plot

;void  draw(int x, int y, int x2, int y2) __smallc
;Note ints are actually uint8_t
draw:
_draw:
	ld	hl,plot
	jp	commondraw
