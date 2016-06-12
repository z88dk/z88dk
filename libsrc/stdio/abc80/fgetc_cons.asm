;
;	ABC80 Routines
;
;	getkey() Wait for keypress
;
;	Maj 2000 - Stefano Bodrato
;
;
;	$Id: fgetc_cons.asm,v 1.5 2016-06-12 17:00:21 dom Exp $
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	
.fgetc_cons
	ld	a,(65013)
	and 127
	jr	z,fgetc_cons
	ld	l,a
	xor a
	ld (65013),a
	ld	h,a
	ret
