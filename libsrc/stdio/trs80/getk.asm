;
;       TRS 80 C Library
;
;	getk() Read key status
;
;	Stefano Bodrato - Apr. 2008
;
;
;	$Id: getk.asm,v 1.1 2008-04-07 07:44:23 stefano Exp $
;


		XLIB	getk

.getk
        call    $2b
        ld      l,a
	ld	h,0
	ret
