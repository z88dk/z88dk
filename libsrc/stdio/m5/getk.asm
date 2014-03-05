;
;	SORD M5 Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 18/5/2001
;
;
;	$Id: getk.asm,v 1.5 2014-03-05 23:01:59 pauloscustodio Exp $
;

	XLIB	getk
	LIB	msxbios

	INCLUDE "m5bios.def"

.getk
	ld	ix,0ACECH
	call	msxbios
	ld	h,0
	ld	l,a
	ret
