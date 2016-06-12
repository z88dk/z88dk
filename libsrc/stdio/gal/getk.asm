;
;       Galaksija C Library
;
;	getk() Read key status
;
;	Stefano Bodrato - Apr. 2008
;
;
;	$Id: getk.asm,v 1.4 2016-06-12 17:07:44 dom Exp $
;


        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

.getk
._getk
        call    $cf5
        ld      l,a
	ld	h,0
	ret
