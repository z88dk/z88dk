;
;       TRS 80 C Library
;
;	getk() Read key status
;
;	Stefano Bodrato - Apr. 2008
;
;
;	$Id: getk.asm,v 1.2 2015-01-19 01:33:21 pauloscustodio Exp $
;


		PUBLIC	getk

.getk
        call    $2b
        ld      l,a
	ld	h,0
	ret
