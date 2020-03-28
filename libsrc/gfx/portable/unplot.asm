
	SECTION	code_graphics

	PUBLIC	unplot
	PUBLIC	_unplot
	PUBLIC	unplot_callee
	PUBLIC	_unplot_callee
	PUBLIC	asm_unplot

	EXTERN	respixel

; int unplot(int x, int y) __smallc;
unplot:
_unplot:
	ld	hl,sp+2
	ld	e,(hl)		;y
	ld	hl,sp+4
	ld	d,(hl)		;x
	ex	de,hl
	jp	respixel

unplot_callee:
_unplot_callee:
	pop	bc		;return
	pop	hl		;y
	pop	de		
	ld	h,e		;x
	push	bc		;return address
asm_unplot:
	jp	respixel
