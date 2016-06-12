;
;	SORD M5 Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 18/5/2001
;
;
;	$Id: getk.asm,v 1.8 2016-06-12 17:07:44 dom Exp $
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk
	EXTERN	msxbios

	INCLUDE "m5bios.def"

.getk
._getk
	ld	ix,0ACECH
	call	msxbios
	ld	h,0
	ld	l,a
	ret
