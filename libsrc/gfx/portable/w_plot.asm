
	SECTION	code_graphics

	PUBLIC	plot
	PUBLIC	_plot
	PUBLIC	plot_callee
	PUBLIC	_plot_callee
	PUBLIC	asm_plot

	EXTERN	w_plotpixel

; int plot(int x, int y) __smallc;
plot:
_plot:
	ld	hl,sp+2
	ld	e,(hl)		;y
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	a,(hl)		;x
	inc	hl
	ld	h,(hl)
	ld	l,a
	jp	w_plotpixel

plot_callee:
_plot_callee:
	pop	bc		;return
	pop	de		;y
	pop	hl		
	push	bc		;return address
asm_plot:
	jp	w_plotpixel
