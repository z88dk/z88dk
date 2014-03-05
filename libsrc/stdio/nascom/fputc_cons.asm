;
;	ROM Console routine for the NASCOM1/2
;	By Stefano Bodrato - 19/6/2003
;
;	$Id: fputc_cons.asm,v 1.2 2014-03-05 23:01:59 pauloscustodio Exp $
;

	XLIB	fputc_cons
	LIB	montest

.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	push	af
	call	montest
	jr	nz,nassys
	
; T monitor
	pop	af
	cp	12
	jr	nz,notcls
	ld	a,1eh
.notcls
	cp	13
	jr	nz,notcr
	ld	a,1fh
.notcr
	jp	0c4ah

.nassys
; NASSYS monitor
	pop	af
	cp	12
	jr	nz,nocls
	ld	a,0ch
.nocls
	defb	0f7h
	ret
