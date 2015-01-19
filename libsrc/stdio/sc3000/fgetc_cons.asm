;
;   SEGA SC-3000 C Library
;
;	getkey() Wait for keypress
;
;	$Id: fgetc_cons.asm,v 1.2 2015-01-19 01:33:21 pauloscustodio Exp $
;

		PUBLIC	fgetc_cons

.fgetc_cons
	call	$42D4
	ld	l,a
	ld	h,0
	ret
