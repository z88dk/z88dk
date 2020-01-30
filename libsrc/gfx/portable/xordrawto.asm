

	SECTION	code_graphics

	PUBLIC	xordrawto
	PUBLIC	_xordrawto

	EXTERN	xorplot
	EXTERN	commondrawto

;void  xordrawto(int x2, int y2) __smallc
;Note ints are actually uint8_t
xordrawto:
_xordrawto:
	ld	hl,xorplot
	jp	commondrawto
