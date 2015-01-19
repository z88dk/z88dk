;
;	Mattel AQUARIUS Routines
;
;	getkey() Wait for keypress
;
;	Dec 2001 - Stefano Bodrato
;
;
;	$Id: fgetc_cons.asm,v 1.2 2015-01-19 01:33:20 pauloscustodio Exp $
;

	PUBLIC	fgetc_cons

.fgetc_cons
	call	$1e80
	and	a
	jr	nz,fgetc_cons

.wkey
	call	$1e80
	and	a
	jr	z,wkey

	ld	l,a
	ld	h,0
	ret
