

	SECTION	code_graphics

	PUBLIC	xorcircle
	PUBLIC	_xorcircle
	PUBLIC	___xorcircle

	EXTERN commoncircle
	EXTERN xorplot

;void  circle(int x, int y, int radius, int skip) __smallc
;Note ints are actually uint8_t
xorcircle:
_xorcircle:
___xorcircle:
	ld	hl,xorplot
	jp	commoncircle
