;
;	Far Call for REX6000
;
;	FarCall function to call code in other mem pages
;	Daniel
;

		XLIB	farcal
		XREF	far_ret
		XREF	far_ret_p
;		XREF	far_ret_sp
;		XREF	far_par1
;		XREF	far_par2
;		XREF	far_par3
;		XREF	far_par4


;.farcall
;	pop	de	;return address
;	pop	hl	;page offset
;	pop	bc	;mem page
;	push	bc
;	push	hl
;	in	a,(1)
;	ld	(far_ret_p),a
;	ex	de,hl
;	ld	hl,4
;	add	hl,sp
;	ld	(far_ret_sp),hl
;	ex	de,hl
;	ld	a,c
;	call	$59ca
	
;.farcal
;	add	ix,sp
;	in	a,(1)
;	ld	(far_ret_p),a
;	ld	hl,14
;	add	hl,sp
;	ld	(far_ret_sp),hl
;	ld	l,(ix+0)
;	ld	h,(ix+1)
;	ld	(far_ret),hl
;	ld	l,(ix+2)
;	ld	h,(ix+3)
;	ld	(far_par4),hl
;	ld	l,(ix+4)
;	ld	h,(ix+5)
;	ld	(far_par3),hl
;	ld	l,(ix+6)
;	ld	h,(ix+7)
;	ld	(far_par2),hl
;	ld	l,(ix+8)
;	ld	h,(ix+9)
;	ld	(far_par1),hl
;	ld	l,(ix+10)
;	ld	h,(ix+11)
;	ld	a,(ix+12)
;	call	$59ca

.farcal
	sla	a
	ld	ix,a
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

