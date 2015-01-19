;
;	Keyboard routines for the Canon X-07
;	By Stefano Bodrato - 10/6/2011
;
;	getkey() Wait for keypress
;
;
;	$Id: fgetc_cons.asm,v 1.2 2015-01-19 01:33:22 pauloscustodio Exp $
;

		PUBLIC	fgetc_cons

.fgetc_cons
	xor	a
	call $C90A
	jr	z,fgetc_cons
	ret
