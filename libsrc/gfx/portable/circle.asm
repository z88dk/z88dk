

	SECTION	code_graphics

	PUBLIC	circle
	PUBLIC	_circle
	PUBLIC	___circle

	EXTERN commoncircle
	EXTERN plot

;void  circle(int x, int y, int radius, int skip) __smallc
;Note ints are actually uint8_t
circle:
_circle:
___circle:
	ld	hl,plot
	jp	commoncircle
