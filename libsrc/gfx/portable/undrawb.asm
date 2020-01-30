

	SECTION	code_graphics

	PUBLIC	undrawb
	PUBLIC	_undrawb

	EXTERN commonbox
	EXTERN unplot

;void  undrawb(int x, int y, int w, int h) __smallc
;Note ints are actually uint8_t
undrawb:
_undrawb:
	ld	hl,unplot
	jp	commonbox
