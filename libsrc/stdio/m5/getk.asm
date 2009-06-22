;
;	SORD M5 Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 18/5/2001
;
;
;	$Id: getk.asm,v 1.4 2009-06-22 21:44:17 dom Exp $
;

	XLIB	getk
	LIB	msxbios

	INCLUDE "m5bios.def"

.getk
	ld	ix,ACECH
	call	msxbios
	ld	h,0
	ld	l,a
	ret
