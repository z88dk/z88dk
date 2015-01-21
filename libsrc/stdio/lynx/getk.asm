;
;       Camputers Lynx C Library
;
;	getk() Read key status
;
;	Stefano Bodrato - 2014
;
;
;	$Id: getk.asm,v 1.2 2015-01-21 08:09:27 stefano Exp $
;


		PUBLIC	getk

.getk
        call    $9bd
        ld      l,a
        ld      h,0
        ret
