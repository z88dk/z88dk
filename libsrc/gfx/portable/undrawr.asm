

	SECTION	code_graphics

	PUBLIC	undrawr
	PUBLIC	_undrawr

	EXTERN	unplot
	EXTERN	commondrawr

;void  undrawr(int x2, int y2) __smallc
;Note ints are actually uint8_t
undrawr:
_undrawr:
	ld	hl,unplot
	jp	commondrawr
