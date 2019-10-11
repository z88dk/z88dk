

	SECTION	code_graphics

	PUBLIC	undrawto
	PUBLIC	_undrawto

	EXTERN	unplot
	EXTERN	commondrawto

;void  undrawto(int x2, int y2) __smallc
;Note ints are actually uint8_t
undrawto:
_undrawto:
	ld	hl,unplot
	jp	commondrawto
