;
;       Galaksija C Library
;
;	getk() Read key status
;
;	Stefano Bodrato - Apr. 2008
;
;
;	$Id: getk.asm,v 1.1 2008-12-09 17:48:18 stefano Exp $
;


		XLIB	getk

.getk
        call    $cf5
        ld      l,a
	ld	h,0
	ret
