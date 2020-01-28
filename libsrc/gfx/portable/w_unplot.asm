
	SECTION	code_graphics

	PUBLIC	unplot
	PUBLIC	_unplot
	PUBLIC	unplot_callee
	PUBLIC	_unplot_callee
	PUBLIC	asm_unplot

	EXTERN	w_respixel

; int unplot(int x, int y) __smallc;
unplot:
_unplot:
	ld	hl,sp+2
	ld	e,(hl)		;y
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	a,(hl)		;x
	inc	hl
	ld	h,(hl)
	ld	l,a
	jp	w_respixel

unplot_callee:
_unplot_callee:
	pop	bc		;return
	pop	de		;y
	pop	hl		
	push	bc		;return address
asm_unplot:
	jp	w_respixel
