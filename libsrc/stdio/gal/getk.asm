;
;       Galaksija C Library
;
;	getk() Read key status
;
;	Stefano Bodrato - Apr. 2008
;
;
;	$Id: getk.asm,v 1.3 2016-06-12 17:00:21 dom Exp $
;


        SECTION code_clib
		PUBLIC	getk

.getk
        call    $cf5
        ld      l,a
	ld	h,0
	ret
