
	SECTION	code_clib

	PUBLIC	w_pointxy

	EXTERN	__laser500_mode
	EXTERN	pointxy_MODE0
	EXTERN	pointxy_MODE2


; in:  hl,de    = (x,y) coordinate of pixel

w_pointxy:
	ld	a,(__laser500_mode)
	cp	2
	jp	z,pointxy_MODE2
	; Reduce coordinates down to h=x, l=y
	ld	a,h
	and	a
	ret	nz
	ld	h,l
	ld	a,d
	and	a
	ret	nz
	ld	l,e
	jp	pointxy_MODE0

