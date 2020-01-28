

	SECTION	code_graphics

	PUBLIC	circle
	PUBLIC	_circle

	EXTERN commoncircle
	EXTERN unplot

;void  circle(int x, int y, int radius, int skip) __smallc
;Note ints are actually uint8_t
circle:
_circle:
	ld	hl,unplot
	jp	commoncircle
