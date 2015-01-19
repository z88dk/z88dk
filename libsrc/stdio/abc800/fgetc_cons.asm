;
;	ABC800 Routines
;
;	getkey() Wait for keypress
;
;	Oct. 2007 - Stefano Bodrato
;
;
;	$Id: fgetc_cons.asm,v 1.2 2015-01-19 01:33:17 pauloscustodio Exp $
;

	PUBLIC	fgetc_cons

.fgetc_cons
	call	2

	ld	l,a
	ld	h,0
	ret
