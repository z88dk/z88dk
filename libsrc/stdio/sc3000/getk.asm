;
;   SEGA SC-3000 C Library
;
;	getk() Read key status
;
;	$Id: getk.asm,v 1.3 2016-06-12 17:32:01 dom Exp $
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

.getk
._getk
	call	$42D4
	ld	l,a
	ld	h,0
	ret
