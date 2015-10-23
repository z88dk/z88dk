;
;	Keyboard routines for the Philips Videopac C7420
;	By Stefano Bodrato - 2015
;
;	getkey() Wait for keypress
;
;
;	$Id: fgetc_cons.asm,v 1.1 2015-10-23 20:34:50 stefano Exp $
;

		PUBLIC	fgetc_cons

.fgetc_cons
	call $1bdf
	or a
	jr	z,fgetc_cons
	ld h,0
	ld l,a
	ret
