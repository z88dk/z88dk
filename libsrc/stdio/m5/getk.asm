;
;	SORD M5 Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 18/5/2001
;
;
;	$Id: getk.asm,v 1.7 2016-06-12 17:00:21 dom Exp $
;

        SECTION code_clib
	PUBLIC	getk
	EXTERN	msxbios

	INCLUDE "m5bios.def"

.getk
	ld	ix,0ACECH
	call	msxbios
	ld	h,0
	ld	l,a
	ret
