
	SECTION	code_clib

	PUBLIC	w_respixel

	EXTERN	__laser500_mode
	EXTERN	res_MODE0
	EXTERN	res_MODE2


; in:  hl,de    = (x,y) coordinate of pixel

w_respixel:
	ld	a,(__laser500_mode)
	cp	2
	jp	z,res_MODE2
	; Reduce coordinates down to h=x, l=y
	ld	a,h
	and	a
	ret	nz
	ld	h,l
	ld	a,d
	and	a
	ret	nz
	ld	l,e
	jp	res_MODE0

