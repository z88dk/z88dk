;
;       Camputers Lynx C Library
;
;	getk() Read key status
;
;	Stefano Bodrato - 2014
;
;
;	$Id: getk.asm,v 1.4 2016-06-12 17:07:44 dom Exp $
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

.getk
._getk
        call    $9bd
IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

        ld      l,a
        ld      h,0
        ret
