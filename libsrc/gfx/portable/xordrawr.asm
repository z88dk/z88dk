

	SECTION	code_graphics

	PUBLIC	xordrawr
	PUBLIC	_xordrawr
	PUBLIC	___xordrawr

	EXTERN	xorplot
	EXTERN	commondrawr

;void  xordrawr(int x2, int y2) __smallc
;Note ints are actually uint8_t
xordrawr:
_xordrawr:
___xordrawr:
	ld	hl,xorplot
	jp	commondrawr
