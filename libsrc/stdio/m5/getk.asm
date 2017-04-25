;
;	SORD M5 Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 18/5/2001
;
;
;	$Id: getk.asm,v 1.8+ (GIT imported) $
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk
	EXTERN	msxbios

	INCLUDE "m5bios.def"

.getk
._getk
	ld	ix,ACECH0
	call	msxbios
	ld	h,0
	ld	l,a
	ret
