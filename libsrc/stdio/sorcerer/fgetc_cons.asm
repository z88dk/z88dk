;
;	Keyboard routines for the Sorcerer Exidy
;	By Stefano Bodrato - 23/05/2011 (exactly 8 years after the Nascom ones !)
;
;	getkey() Wait for keypress
;
;
;	$Id: fgetc_cons.asm,v 1.2 2015-01-19 01:33:21 pauloscustodio Exp $
;

		PUBLIC	fgetc_cons

.fgetc_cons
	call $e009
	jr	z,fgetc_cons
	ld	l,a
	ld	h,0
	ret
