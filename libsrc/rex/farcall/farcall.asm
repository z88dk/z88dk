;
;	Far Call for REX6000
;
;	FarCall function to call code in other mem pages
;	Daniel
;

		XLIB	farcall
		XREF	far_ret
		XREF	far_ret_p


.farcall
	sla	a
	ld	b,0
	ld	c,a
	ld	ix,0
	add	ix,bc
	add	ix,sp
	ld	c,(ix+0)	;Lib page
	ld	e,(ix-2)	;Lib adr
	ld	d,(ix-1)
	pop	hl
	ld	(far_ret),hl
	in	a,(1)
	ld	(far_ret_p),a
	ld	hl,$8030
	push	hl
	push	de
	ld	a,c
	jp	$26ea

