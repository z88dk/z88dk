;
;	SORD M5 Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: fgetc_cons.asm,v 1.4 2009-06-22 21:44:17 dom Exp $
;

	XLIB	fgetc_cons
	LIB	msxbios

	INCLUDE "m5bios.def"

.fgetc_cons
	ld	ix,ACECHI
	call	msxbios
	ld	h,0
	ld	l,a
	ret
