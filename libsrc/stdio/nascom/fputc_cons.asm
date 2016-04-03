;
;	ROM Console routine for the NASCOM1/2
;	By Stefano Bodrato - 19/6/2003
;
;	$Id: fputc_cons.asm,v 1.4 2016-04-03 13:10:24 dom Exp $
;

	SECTION	code_clib
	PUBLIC	fputc_cons
	EXTERN	montest

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
