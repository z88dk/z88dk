;
;       Galaksija C Library
;
;	getk() Read key status
;
;	Stefano Bodrato - Apr. 2008
;
;
;	$Id: getk.asm,v 1.2 2015-01-19 01:33:20 pauloscustodio Exp $
;


		PUBLIC	getk

.getk
        call    $cf5
        ld      l,a
	ld	h,0
	ret
