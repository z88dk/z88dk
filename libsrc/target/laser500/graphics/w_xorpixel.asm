
	SECTION	code_clib

	PUBLIC	w_xorpixel

	EXTERN	__laser500_mode
	EXTERN	xor_MODE0
	EXTERN	xor_MODE2


; in:  hl,de    = (x,y) coordinate of pixel

w_xorpixel:
	ld	a,(__laser500_mode)
	cp	2
	jp	z,xor_MODE2
	; Reduce coordinates down to h=x, l=y
	ld	a,h
	and	a
	ret	nz
	ld	h,l
	ld	a,d
	and	a
	ret	nz
	ld	l,e
	jp	xor_MODE0

