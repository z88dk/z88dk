;
;	Mattel AQUARIUS Routines
;
;	getk() Read key status
;
;	Dec 200i - Stefano Bodrato
;
;
;	$Id: getk.asm,v 1.3 2016-06-12 17:00:21 dom Exp $
;

        SECTION code_clib
	PUBLIC	getk

.getk
	call	$1e80
	ld	l,a
	ld	h,0
	ret
