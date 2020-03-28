
	SECTION	code_graphics

	PUBLIC	xorplot
	PUBLIC	_xorplot
	PUBLIC	xorplot_callee
	PUBLIC	_xorplot_callee
	PUBLIC	asm_xorplot

	EXTERN	xorpixel

; int xorplot(int x, int y) __smallc;
xorplot:
_xorplot:
	ld	hl,sp+2
	ld	e,(hl)		;y
	ld	hl,sp+4
	ld	d,(hl)		;x
	ex	de,hl
	jp	xorpixel

xorplot_callee:
_xorplot_callee:
	pop	bc		;return
	pop	hl		;y
	pop	de		
	ld	h,e		;x
	push	bc		;return address
asm_xorplot:
	jp	xorpixel
