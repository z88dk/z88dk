

	SECTION	code_graphics

	PUBLIC	xordraw
	PUBLIC	_xordraw
	PUBLIC	___xordraw

	EXTERN	xorplot
	EXTERN	commondraw

;void  xordraw(int x, int y, int x2, int y2) __smallc
;Note ints are actually uint8_t
xordraw:
_xordraw:
___xordraw:
	ld	hl,xorplot
	jp	commondraw
