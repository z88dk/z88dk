;
;	Philips P2000
;
;	getkey() Wait for keypress
;
;	Apr 2014 - Stefano Bodrato
;
;
;	$Id: fgetc_cons.asm,v 1.1 2014-04-17 06:16:05 stefano Exp $
;

	XLIB	fgetc_cons

fgetc_cons:
	call 1956h

	ld	l,a
	ld	h,0
	ret
