
	SECTION	code_clib

	PUBLIC	w_plotpixel

	EXTERN	__laser500_mode
	EXTERN	plot_MODE0
	EXTERN	plot_MODE2


; in:  hl,de    = (x,y) coordinate of pixel

w_plotpixel:
	ld	a,(__laser500_mode)
	cp	2
	jp	z,plot_MODE2
	; Reduce coordinates down to h=x, l=y
	ld	a,h
	and	a
	ret	nz
	ld	h,l
	ld	a,d
	and	a
	ret	nz
	ld	l,e
	jp	plot_MODE0

