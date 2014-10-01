;
;	ABC80 Routines
;
;	getkey() Wait for keypress
;
;	Maj 2000 - Stefano Bodrato
;
;
;	$Id: fgetc_cons.asm,v 1.3 2014-10-01 20:27:22 stefano Exp $
;

	XLIB	fgetc_cons
	
.fgetc_cons
	ld	a,(65013)
	and 127
	jr	z,fgetc_cons
	ld	l,a
	xor a
	ld (65013),a
	ld	h,a
	ret
