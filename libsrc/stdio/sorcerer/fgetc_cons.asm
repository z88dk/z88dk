;
;	Keyboard routines for the Sorcerer Exidy
;	By Stefano Bodrato - 23/05/2011 (exactly 8 years after the Nascom ones !)
;
;	getkey() Wait for keypress
;
;
;	$Id: fgetc_cons.asm,v 1.1 2011-05-24 18:11:10 stefano Exp $
;

		XLIB	fgetc_cons

.fgetc_cons
	call $e009
	jr	z,fgetc_cons
	ld	l,a
	ld	h,0
	ret
