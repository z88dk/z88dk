;
;	Mattel AQUARIUS Routines
;
;	getk() Read key status
;
;	Dec 200i - Stefano Bodrato
;
;
;	$Id: getk.asm,v 1.4 2016-06-12 17:07:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

.getk
._getk
	call	$1e80
	ld	l,a
	ld	h,0
	ret
