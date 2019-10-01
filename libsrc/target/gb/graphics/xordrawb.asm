

	SECTION	code_graphics

	PUBLIC	xordrawb
	PUBLIC	_xordrawb

	EXTERN commonbox
	EXTERN	xorplot

;void  xordrawb(int x, int y, int w, int h) __smallc
;Note ints are actually uint8_t
xordrawb:
_xordrawb:
	ld	hl,xorplot
	jp	commonbox
