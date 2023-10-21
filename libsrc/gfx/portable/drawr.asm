

	SECTION	code_graphics

	PUBLIC	drawr
	PUBLIC	_drawr
	PUBLIC	___drawr

	EXTERN commondrawr
	EXTERN plot

;void  drawr(int x2, int y2) __smallc
;Note ints are actually uint8_t
drawr:
_drawr:
___drawr:
	ld	hl,plot
	jp	commondrawr
