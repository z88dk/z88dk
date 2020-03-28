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
	PUBLIC	_getk

.getk
._getk
        ld      a,(65013)
        and 127

IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF
	ld	l,a
	ld	h,0
	xor	a
	ld	(65013),a
	ret
