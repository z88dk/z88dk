

	SECTION	code_graphics

	PUBLIC	undraw
	PUBLIC	_undraw

	EXTERN	unplot
	EXTERN	commondraw

;void  undraw(int x, int y, int x2, int y2) __smallc
;Note ints are actually uint8_t
undraw:
_undraw:
	ld	hl,unplot
	jp	commondraw
