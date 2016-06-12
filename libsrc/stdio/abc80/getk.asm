;
;	ABC80 Routines
;
;	getk() Read key status
;
;	Maj 2000 - Stefano Bodrato
;
;
;	$Id: getk.asm,v 1.5 2016-06-12 17:00:21 dom Exp $
;

        SECTION code_clib
	PUBLIC	getk

.getk
	in	a,(56)
	and 127
	ld	l,a
	ld	h,0
	ret
