;
;	ABC800 Routines
;
;	getk() Read key status
;
;	Oct 2007 - Stefano Bodrato
;
;
;	$Id: getk.asm,v 1.3 2016-06-12 17:00:21 dom Exp $
;

        SECTION code_clib
	PUBLIC	getk

.getk
	call	2

	ld	l,a
	ld	h,0
	ret
