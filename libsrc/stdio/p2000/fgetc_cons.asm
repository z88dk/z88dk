;
;	Philips P2000
;
;	getkey() Wait for keypress
;
;	Apr 2014 - Stefano Bodrato
;
;
;	$Id: fgetc_cons.asm,v 1.2 2015-01-19 01:33:21 pauloscustodio Exp $
;

	PUBLIC	fgetc_cons

fgetc_cons:
	call 1956h

	ld	l,a
	ld	h,0
	ret
