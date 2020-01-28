
	SECTION	code_graphics

	PUBLIC	plot
	PUBLIC	_plot
	PUBLIC	plot_callee
	PUBLIC	_plot_callee
	PUBLIC	asm_plot

	EXTERN	plotpixel

; int plot(int x, int y) __smallc;
plot:
_plot:
	ld	hl,sp+2
	ld	e,(hl)		;y
	ld	hl,sp+4
	ld	d,(hl)		;x
	ex	de,hl
	jp	plotpixel

plot_callee:
_plot_callee:
	pop	bc		;return
	pop	hl		;y
	pop	de		
	ld	h,e		;x
	push	bc		;return address
asm_plot:
	jp	plotpixel
