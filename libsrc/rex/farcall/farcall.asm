;
;	Far Call for REX6000
;
;	FarCall function to call code in other mem pages
;	Daniel
;
;	$Id: farcall.asm,v 1.1 2002-01-18 12:06:40 dom Exp $


		XLIB	farcall
		XREF	far_ret
		XREF	far_ret_p
		XREF	far_ret_sp


.farcall
	pop	de	;return address
	pop	hl	;page offset
	pop	bc	;mem page
	push	bc
	push	hl
	in	a,(1)
	ld	(far_ret_p),a
	ld	(far_ret),de
	ex	de,hl
	ld	hl,4
	add	hl,sp
	ld	(far_ret_sp),hl
	ex	de,hl
	ld	a,c
	call	$59ca



