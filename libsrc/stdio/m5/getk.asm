;
;	SORD M5 Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 18/5/2001
;
;
;	$Id: getk.asm,v 1.6 2015-01-19 01:33:20 pauloscustodio Exp $
;

	PUBLIC	getk
	EXTERN	msxbios

	INCLUDE "m5bios.def"

.getk
	ld	ix,0ACECH
	call	msxbios
	ld	h,0
	ld	l,a
	ret
