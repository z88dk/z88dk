
	SECTION	code_graphics

	PUBLIC	xorplot
	PUBLIC	_xorplot
	PUBLIC	xorplot_callee
	PUBLIC	_xorplot_callee
	PUBLIC	asm_xorplot

	EXTERN	w_xorpixel

; int xorplot(int x, int y) __smallc;
xorplot:
_xorplot:
	ld	hl,sp+2
	ld	e,(hl)		;y
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	a,(hl)		;x
	inc	hl
	ld	h,(hl)
	ld	l,a
	jp	w_xorpixel

xorplot_callee:
_xorplot_callee:
	pop	bc		;return
	pop	de		;y
	pop	hl		
	push	bc		;return address
asm_xorplot:
	jp	w_xorpixel
